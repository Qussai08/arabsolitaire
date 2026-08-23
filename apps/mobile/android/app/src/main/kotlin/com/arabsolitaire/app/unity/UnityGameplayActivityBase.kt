package com.arabsolitaire.app.unity

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.arabsolitaire.app.BuildConfig

/**
 * Fallback Activity when unityLibrary export is absent.
 */
open class UnityGameplayActivityBase : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!BuildConfig.UNITY_LIBRARY_AVAILABLE) {
            setResult(
                RESULT_CANCELED,
                Intent().putExtra(
                    UnityRuntimeController.EXTRA_ERROR_CODE,
                    BridgeTransportError.RuntimeNotReady.code,
                ),
            )
            finish()
        }
    }

    fun onUnityMessage(json: String) {
        UnityBridgePlugin.dispatchUnityMessage(json)
    }
}
