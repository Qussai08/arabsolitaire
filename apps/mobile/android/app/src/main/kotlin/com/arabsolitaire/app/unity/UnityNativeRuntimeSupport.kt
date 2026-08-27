package com.arabsolitaire.app.unity

import android.os.Build

/**
 * Unity export ships arm64-v8a native libraries only. The process primary ABI must
 * match or [UnityPlayerGameActivity] fails to load `libgame.so`.
 */
object UnityNativeRuntimeSupport {
    const val REQUIRED_ABI = "arm64-v8a"

    fun isSupported(
        unityLibraryAvailable: Boolean,
        supportedAbis: Array<String> = Build.SUPPORTED_ABIS,
    ): Boolean {
        if (!unityLibraryAvailable) {
            return false
        }
        val primaryAbi = supportedAbis.firstOrNull() ?: return false
        return primaryAbi == REQUIRED_ABI
    }
}
