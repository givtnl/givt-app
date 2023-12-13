#import "DeviceRegionPlugin.h"
#if __has_include(<device_region/device_region-Swift.h>)
#import <device_region/device_region-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "device_region-Swift.h"
#endif

@implementation DeviceRegionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceRegionPlugin registerWithRegistrar:registrar];
}
@end
