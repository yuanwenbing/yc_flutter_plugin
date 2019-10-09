import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:yc_flutter_plugin/src/net/interceptor/header_params_interceptor.dart';
import 'package:yc_flutter_plugin/src/net/interceptor/host_interceptor.dart';

import 'cache/cache_manager.dart';

enum RequestCategory { NET, CACHE, BOTH }

Map<String, dynamic> _publicParams;

class NetUtils {
  static const String BASE_URL = 'https://mapi.yiche.com';

  static NetUtils _instance;

  static const String GET = "get";
  static const String POST = "post";

  static void setPublicParams(Map<String, dynamic> publicParams) {
    _publicParams = publicParams;
  }

  static NetUtils instance() {
    if (_instance == null) {
      _instance = NetUtils();
    }
    return _instance;
  }

  Dio _dio = new Dio();

  NetUtils() {
    _dio.options.connectTimeout = 30 * 1000;
    _dio.options.receiveTimeout = 30 * 1000;
    bool release = const bool.fromEnvironment("dart.vm.product"); // 是否是release环境
    _dio.interceptors.add(LogInterceptor(responseBody: !release)); //是否开启请求日志
    _dio.interceptors.add(HostInterceptor(forceHttps: false));
    _dio.interceptors.add(HeaderParamsInterceptor(""));
    _dio.options.followRedirects = true;
    Map<String, dynamic> headers = new Map();
    if (_publicParams != null) {
      headers.addAll(_publicParams);
    }
    _dio.options.headers = headers;
  }

  void request(
    String url,
    Function callBack, {
    String baseUrl = BASE_URL,
    String method = GET,
    Map<String, String> params,
    Function errorCallBack,
    Function cacheCallBack,
    RequestCategory category = RequestCategory.NET,
  }) {
    // 纯缓存
    if (category == RequestCategory.CACHE) {
      _readCache(url, cacheCallBack, errorCallback: errorCallBack);
      return;
    }

    // 纯网络
    if (category == RequestCategory.NET) {
      _requestHttp(url, callBack, method: method, params: params, errorCallBack: errorCallBack, category: category);
      return;
    }

    // 先缓存后网络，某些特殊情况，网络甚至比本地快，所以采用先本地后网络的方式
    if (category == RequestCategory.BOTH) {
      Future cacheFuture = _readCache(url, cacheCallBack, errorCallback: errorCallBack);
      cacheFuture.then((value) {
        _requestHttp(url, callBack, method: method, params: params, errorCallBack: errorCallBack, category: category);
      }).catchError((onError) {
        _requestHttp(url, callBack, method: method, params: params, errorCallBack: errorCallBack, category: category);
      });
    }
  }

  /*
   * 请求缓存
   * 内部使用Lru策略实现
   */
  _readCache(String key, Function cacheCallBack, {Function errorCallback}) {
    return CacheManager().readCache(key.hashCode.toString()).then((cache) {
      if (cache != null && cache.isNotEmpty) {
        cacheCallBack(json.decode(cache));
      }
    }).catchError((onError) {
      print("onError = $onError");
    });
  }

  _saveCache(String url, String json) {
    try {
      if (url != null && url.isNotEmpty && json != null && json.isNotEmpty) {
        CacheManager().saveCache(url.hashCode.toString(), json);
      }
    } catch (e) {
      print(e);
    }
  }

  _requestHttp(String url, Function callBack,
      {String method, Map<String, String> params, Function errorCallBack, RequestCategory category}) async {
    String errorMsg = "";
    int statusCode;
    try {
      Response response;
      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }
        response = await _dio.get(url);
      } else {
        if (params != null && params.isNotEmpty) {
          response = await _dio.post(url, data: params);
        } else {
          response = await _dio.post(url);
        }
      }

      statusCode = response.statusCode;

      if (statusCode < 0) {
        errorMsg = "errorCode = " + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }

      if (callBack != null) {
        Map<String, dynamic> data = response.data;
        callBack(data);
        String originalJson = json.encode(response.data);
        _saveCache(url, originalJson);
      }
    } catch (exception) {
      _handError(errorCallBack, exception.toString());
    }
  }

  void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }
}
