package com.arabsolitaire.app

import com.arabsolitaire.app.unity.UnityBridgePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
        flutterEngine.plugins.add(UnityBridgePlugin())
    }

    companion object {
        const val ENGINE_ID = "main"
    }
}
