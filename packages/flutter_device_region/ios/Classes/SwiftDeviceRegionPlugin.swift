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
                do {
                    let networkProviders = try CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
                    var countryCode = try networkProviders?.first?.value.isoCountryCode ?? nil

                    if(countryCode != nil){
                        result(countryCode)
                        return
                    } else {
                        if #available(iOS 16, *)  {
                            countryCode = Locale.current.region?.identifier
                        } else {
                            countryCode = Locale.current.regionCode
                        }

                        if(countryCode != nil){
                            result(countryCode)
                            return
                        }
                    }

                    result(
                        FlutterError(
                            code: "ERROR",
                            message: "SIM country code not found",
                            details: nil
                        )
                    )
                } catch {
                    result(
                        FlutterError(
                            code: "ERROR",
                            message: "SIM country code not found",
                            details: nil
                        )
                    )
                }
            } else {
                result(
                    FlutterError(
                        code: "ERROR",
                        message: "iOS version not supported",
                        details: nil
                    )
                )
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
