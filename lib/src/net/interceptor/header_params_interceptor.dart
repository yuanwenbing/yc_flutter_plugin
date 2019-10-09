import 'dart:collection';

import 'package:dio/dio.dart';
import 'dart:async';

class HeaderParamsInterceptor extends Interceptor {
  //客户端来源标,100:android-易车app  200：ios-易车app
  static const String KEY_CID = "cid";

  //USERID
  static const String KEY_UID = "uid";

  //客户端版本号	建议使用数值
  static const String KEY_VER = "ver";

  //必填	时间戳
  static const String KEY_T = "t";

  //设备号 兼容老接口
  static const String KEY_DEVID = "devid";

  //设备号2	新接口使用，大数据团队使用对是这个dvid
  static const String KEY_DVID = "dvid";

  //渠道号
  static const String KEY_CHANNELID = "channelid";

  //用户信息	该字段app会逐渐弃用
  static const String KEY_COOKIE = "cookie";

  //必填	系统版本号
  static const String KEY_OS = "os";

  //必填	签名
  static const String KEY_SIGN = "sign";

  //需要找相关人员索取
  static const String key = "F3A11874B1F347A8A29056F84CCFCD82";

  String cid = "100";

  HeaderParamsInterceptor(this.cid);

  @override
  FutureOr onRequest(RequestOptions options) {
    Uri uri = options.uri;
    if(uri.host == "mapi.yiche.com") {
      var headers = options.headers;
      if (headers == null) {
        headers = new HashMap();
      }
      DateTime dateTime = new DateTime.now();
      headers[KEY_T] = dateTime.millisecondsSinceEpoch;
    }
    return super.onRequest(options);
  }
}
