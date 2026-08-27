package com.arabsolitaire.app.unity

import android.os.Bundle
import com.unity3d.player.UnityPlayer
import com.unity3d.player.UnityPlayerGameActivity

/**
 * Full-screen Unity player Activity (requires generated unityLibrary module).
 */
class UnityGameplayActivity : UnityPlayerGameActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Prefer GLES on older Mali/Exynos devices (Vulkan often yields a black screen).
        if (intent.getStringExtra("unity") == null) {
            intent.putExtra("unity", "-force-gles")
        }

        super.onCreate(savedInstanceState)
        requestedOrientation = android.content.pm.ActivityInfo.SCREEN_ORIENTATION_PORTRAIT

        val plugin = UnityBridgePlugin.instance ?: return
        val controller = plugin.runtimeController
        controller.attachUnitySender { json ->
            UnityPlayer.UnitySendMessage(
                "FlutterBridgeReceiver",
                "OnFlutterMessage",
                json,
            )
        }

        // Receiver exists only after Bootstrap Awake — delay session configure.
        window.decorView.postDelayed({
            UnityPlayer.UnitySendMessage(
                "FlutterBridgeReceiver",
                "ConfigureSession",
                buildSessionPayload(),
            )
        }, 1500)
        // Do not markUnityReady here — wait for first Unity→Flutter message.
    }

    override fun onPause() {
        super.onPause()
        UnityBridgePlugin.instance?.runtimeController?.pauseUnity()
    }

    override fun onResume() {
        super.onResume()
        UnityBridgePlugin.instance?.runtimeController?.resumeUnity()
    }

    override fun onDestroy() {
        UnityBridgePlugin.instance?.runtimeController?.shutdown()
        super.onDestroy()
    }

    /** Called from Unity via JNI on the current Activity. */
    fun onUnityMessage(json: String) {
        val controller = UnityBridgePlugin.instance?.runtimeController ?: return
        controller.markUnityReady()
        controller.onUnityMessage(json)
    }

    private fun buildSessionPayload(): String {
        val sessionId = intent.getStringExtra(UnityRuntimeController.EXTRA_SESSION_ID).orEmpty()
        val attemptId = intent.getStringExtra(UnityRuntimeController.EXTRA_ATTEMPT_ID).orEmpty()
        val levelDefinitionId =
            intent.getStringExtra(UnityRuntimeController.EXTRA_LEVEL_DEFINITION_ID).orEmpty()
        return listOf(sessionId, attemptId, levelDefinitionId).joinToString("|")
    }
}
