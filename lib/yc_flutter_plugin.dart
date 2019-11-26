//import 'dart:async';
//
//import 'package:flutter/services.dart';
//
//class YcFlutterPlugin {
//  static const MethodChannel _channel =
//      const MethodChannel('yc_flutter_plugin');
//
//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }
//}

library yc_common;

export 'package:pull_to_refresh/pull_to_refresh.dart';
export 'src/ui/refresh/yc_refresh.dart';
export 'src/ui/toast/toast.dart';
export 'src/ui/loading/yc_loading.dart';
export 'src/image/yc_image_cache_manager.dart';
export 'src/image/yc_image.dart';
export 'src/net/net_utils.dart';
export 'src/utils/event.dart';

