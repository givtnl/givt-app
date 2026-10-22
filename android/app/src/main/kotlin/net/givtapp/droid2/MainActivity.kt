package net.givtapp.droid2

import android.webkit.WebSettings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "net.givtapp/webview",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsableWebView" -> {
                    try {
                        WebSettings.getDefaultUserAgent(applicationContext)
                        result.success(true)
                    } catch (t: Throwable) {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}