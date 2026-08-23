package com.arabsolitaire.app.unity

import android.app.Activity
import com.arabsolitaire.app.BuildConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UnityBridgePlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activityBinding: ActivityPluginBinding? = null

    private val broker = UnityMessageBroker()
    private lateinit var runtimeControllerInternal: UnityRuntimeController

    internal val runtimeController: UnityRuntimeController
        get() = runtimeControllerInternal

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        runtimeControllerInternal = UnityRuntimeController(
            appContext = binding.applicationContext,
            broker = broker,
            unityLibraryAvailable = BuildConfig.UNITY_LIBRARY_AVAILABLE,
        )
        instance = this

        methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            },
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        broker.destroy()
        instance = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> result.success(BuildConfig.UNITY_LIBRARY_AVAILABLE)
            "openGameplay" -> handleOpenGameplay(call, result)
            "sendToUnity" -> handleSendToUnity(call, result)
            "pauseUnity" -> {
                runtimeController.pauseUnity()
                result.success(null)
            }
            "resumeUnity" -> {
                runtimeController.resumeUnity()
                result.success(null)
            }
            "shutdownUnity" -> {
                runtimeController.shutdown()
                result.success(null)
            }
            "finishUnityActivity" -> {
                val activity = activityBinding?.activity
                if (activity != null) {
                    runtimeController.finishUnityActivity(activity)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleOpenGameplay(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityBinding?.activity
        if (activity == null) {
            result.error("no_activity", "Activity unavailable", null)
            return
        }

        val args = UnityLaunchArgs(
            sessionId = call.argument<String>("sessionId").orEmpty(),
            attemptId = call.argument<String>("attemptId").orEmpty(),
            levelDefinitionId = call.argument<String>("levelDefinitionId").orEmpty(),
            chapterId = call.argument<String>("chapterId").orEmpty(),
        )

        val error = runtimeController.openGameplay(activity, args)
        if (error != null) {
            result.error(error.code, error.name, null)
            return
        }
        result.success(null)
    }

    private fun handleSendToUnity(call: MethodCall, result: MethodChannel.Result) {
        val json = call.argument<String>("json")
        if (json.isNullOrBlank()) {
            result.error(
                BridgeTransportError.EmptyPayload.code,
                BridgeTransportError.EmptyPayload.name,
                null,
            )
            return
        }

        val error = runtimeController.sendToUnity(json)
        if (error != null) {
            result.error(error.code, error.name, null)
            return
        }
        result.success(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener { requestCode, resultCode, data ->
            runtimeController.handleActivityResult(requestCode, resultCode, data)
            false
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    internal fun dispatchUnityMessage(json: String) {
        eventSink?.success(json)
    }

    companion object {
        private const val CHANNEL = "com.arabsolitaire/unity_bridge"
        private const val EVENT_CHANNEL = "com.arabsolitaire/unity_bridge/events"

        @Volatile
        internal var instance: UnityBridgePlugin? = null

        fun dispatchUnityMessage(json: String) {
            instance?.dispatchUnityMessage(json)
        }
    }
}
