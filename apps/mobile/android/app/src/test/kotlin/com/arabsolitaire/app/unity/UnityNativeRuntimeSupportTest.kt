package com.arabsolitaire.app.unity

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class UnityNativeRuntimeSupportTest {
    @Test
    fun returnsFalseWhenUnityLibraryAbsent() {
        assertFalse(
            UnityNativeRuntimeSupport.isSupported(
                unityLibraryAvailable = false,
                supportedAbis = arrayOf("arm64-v8a"),
            ),
        )
    }

    @Test
    fun returnsFalseWhenPrimaryAbiIsX86_64() {
        assertFalse(
            UnityNativeRuntimeSupport.isSupported(
                unityLibraryAvailable = true,
                supportedAbis = arrayOf("x86_64", "arm64-v8a"),
            ),
        )
    }

    @Test
    fun returnsTrueWhenPrimaryAbiIsArm64() {
        assertTrue(
            UnityNativeRuntimeSupport.isSupported(
                unityLibraryAvailable = true,
                supportedAbis = arrayOf("arm64-v8a"),
            ),
        )
    }
}
