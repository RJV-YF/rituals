package com.example.rituals

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val bridge = AlarmBridge(this)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AlarmBridge.CHANNEL,
        ).setMethodCallHandler { call, result -> bridge.handle(call, result) }
    }
}
