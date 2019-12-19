import 'dart:async';

import 'package:dio/dio.dart';

class HostInterceptor extends Interceptor {
  Set<String> bpHosts = new Set();

  // 是否强制https
  bool forceHttps;

  HostInterceptor({this.forceHttps = false}) {
    bpHosts.add("appapi-gw.yiche.com");
    bpHosts.add("gw.ycapp.yiche.com");
    bpHosts.add("newsapi.yiche.com");
    bpHosts.add("photo.m.yiche.com");
    bpHosts.add("webapi.photo.bitauto.com");
    bpHosts.add("photoapi.yiche.com");
    bpHosts.add("carwebapi.yiche.com");
    bpHosts.add("carclue.bitauto.com");
    bpHosts.add("carclue.m.yiche.com");
    bpHosts.add("mpsapi.yiche.com");
    bpHosts.add("carapi.app.yiche.com");
    bpHosts.add("selectcar.yiche.com");
    bpHosts.add("select.car.yiche.com");
    bpHosts.add("koubeiapi.yiche.com");
    bpHosts.add("luocjapi.yiche.com");
    bpHosts.add("api.ycapp.yiche.com");
    bpHosts.add("carapi.ycapp.yiche.com");
    bpHosts.add("cheyouapi.ycapp.yiche.com");
    bpHosts.add("extapi.ycapp.yiche.com");
    bpHosts.add("h5.ycapp.yiche.com");
    bpHosts.add("hd.ycapp.yiche.com");
    bpHosts.add("hao.m.yiche.com");
    bpHosts.add("hao.yiche.com");
    //bpHosts.add("log.ycapp.yiche.com");
    bpHosts.add("mp.ycapp.yiche.com");
    bpHosts.add("sapi.ycapp.yiche.com");
    bpHosts.add("searchapi.ycapp.yiche.com");
    bpHosts.add("userapi.ycapp.yiche.com");
    bpHosts.add("yiqishuo.yiche.com");
    bpHosts.add("yiqishuo.m.yiche.com");
    bpHosts.add("mallapi.yiche.com");
    bpHosts.add("mapi.yiche.com");
  }

  @override
  Future onRequest(RequestOptions options) {
    bool release = const bool.fromEnvironment("dart.vm.product"); // 是否是release环境
    if (release || forceHttps) {
      if (options.uri.isScheme("http")) {
        var replace = options.uri.replace(scheme: "https");
        options.path = replace.toString();
      }
    }

    return super.onRequest(options);
  }
}
