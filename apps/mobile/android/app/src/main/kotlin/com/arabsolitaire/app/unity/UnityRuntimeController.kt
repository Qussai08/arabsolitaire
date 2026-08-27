package com.arabsolitaire.app.unity

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngineCache

/**
 * Owns Unity Activity launch/shutdown and broker wiring to cached FlutterEngine.
 */
class UnityRuntimeController(
    private val appContext: Context,
    private val broker: UnityMessageBroker,
    private val unityLibraryAvailable: Boolean,
) {
    private var activeLaunch: UnityLaunchArgs? = null
    private var exitRequested = false

    fun isAvailable(): Boolean =
        UnityNativeRuntimeSupport.isSupported(unityLibraryAvailable)

    fun openGameplay(activity: Activity, args: UnityLaunchArgs): BridgeTransportError? {
        if (!isAvailable()) {
            return BridgeTransportError.RuntimeNotReady
        }

        exitRequested = false
        activeLaunch = args
        broker.configureSession(args.sessionId)
        broker.onMessageToFlutter = { json ->
            UnityBridgePlugin.dispatchUnityMessage(json)
        }

        val intent = Intent(activity, UnityGameplayActivity::class.java).apply {
            putExtra(EXTRA_SESSION_ID, args.sessionId)
            putExtra(EXTRA_ATTEMPT_ID, args.attemptId)
            putExtra(EXTRA_LEVEL_DEFINITION_ID, args.levelDefinitionId)
            putExtra(EXTRA_CHAPTER_ID, args.chapterId)
        }
        activity.startActivityForResult(intent, REQUEST_CODE_GAMEPLAY)
        return null
    }

    fun sendToUnity(json: String): BridgeTransportError? = broker.onFlutterToUnity(json)

    fun markUnityReady() {
        broker.markUnityReady()
    }

    fun pauseUnity() = broker.pause()

    fun resumeUnity() = broker.resume()

    fun shutdown() {
        broker.shutdown()
        activeLaunch = null
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != REQUEST_CODE_GAMEPLAY) {
            return
        }
        activeLaunch = null
        broker.shutdown()
    }

    fun handleExitRequest(): Boolean {
        if (exitRequested) {
            return false
        }
        exitRequested = true
        return true
    }

    fun finishUnityActivity(activity: Activity, resultCode: Int = Activity.RESULT_OK) {
        activity.setResult(resultCode)
        activity.finish()
    }

    fun onUnityMessage(json: String) {
        broker.onUnityToFlutter(json)
    }

    fun attachUnitySender(sender: (String) -> Unit) {
        broker.onSendToUnity = sender
    }

    companion object {
        const val REQUEST_CODE_GAMEPLAY = 9101
        const val EXTRA_SESSION_ID = "sessionId"
        const val EXTRA_ATTEMPT_ID = "attemptId"
        const val EXTRA_LEVEL_DEFINITION_ID = "levelDefinitionId"
        const val EXTRA_CHAPTER_ID = "chapterId"
        const val EXTRA_ERROR_CODE = "errorCode"

        fun cachedEngineAvailable(): Boolean =
            FlutterEngineCache.getInstance().get("main") != null
    }
}
