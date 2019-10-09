#import "YcFlutterPlugin.h"
#import <yc_flutter_plugin/yc_flutter_plugin-Swift.h>

@implementation YcFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYcFlutterPlugin registerWithRegistrar:registrar];
}
@end
