#import "FlutterOguryPlugin.h"
#if __has_include(<flutter_ogury/flutter_ogury-Swift.h>)
#import <flutter_ogury/flutter_ogury-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ogury-Swift.h"
#endif

@implementation FlutterOguryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterOguryPlugin registerWithRegistrar:registrar];
}
@end
