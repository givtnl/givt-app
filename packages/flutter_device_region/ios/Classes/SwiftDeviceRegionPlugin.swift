import Flutter
import UIKit
import CoreTelephony

public class SwiftDeviceRegionPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "device_region", binaryMessenger: registrar.messenger())
        let instance = SwiftDeviceRegionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getSIMCountryCode"){
            if #available(iOS 12.0, *) {
                let networkProviders = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
                let countryCode = networkProviders?.first?.value.isoCountryCode ?? nil
                
                result(countryCode)
            } else {
                result(nil)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
