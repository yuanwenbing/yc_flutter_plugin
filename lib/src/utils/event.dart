import 'package:flutter/services.dart';
import 'package:yc_flutter_plugin/src/net/net_utils.dart';
import 'package:yc_flutter_plugin/yc_platform_plugins.dart';

class Event {

  static void sendDisplay() {
    NetUtils.instance().request("", (response) {});
  }

  static void sendClick() {
    NetUtils.instance().request("", (response) {});
  }

}
