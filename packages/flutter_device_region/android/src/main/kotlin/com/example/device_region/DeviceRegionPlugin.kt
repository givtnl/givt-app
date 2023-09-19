package com.example.device_region

import androidx.annotation.NonNull
import android.content.Context
import android.telephony.TelephonyManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DeviceRegionPlugin */
class DeviceRegionPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_region")
    channel.setMethodCallHandler(this)

    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getSIMCountryCode") {
      try {
        val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val simCountry = tm.simCountryIso
        
        if (simCountry != null && simCountry.length == 2) { // SIM country code is available
            result.success(simCountry)
        } 
        else if (tm.phoneType != TelephonyManager.PHONE_TYPE_CDMA) { // Device is not 3G (would be unreliable)
            val networkCountry = tm.networkCountryIso
            
            if (networkCountry != null && networkCountry.length == 2) { // network country code is available
                result.success(networkCountry)
            }
        }
      }
      catch (e: Exception) {
        result.error("ERROR", e.message, null)
      }
    } else {
      result.notImplemented()
    }

    result.error("ERROR", "No country code available", null)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
