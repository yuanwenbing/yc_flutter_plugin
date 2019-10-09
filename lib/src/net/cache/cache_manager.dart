import "disk_lru_cache.dart";
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  static CacheManager _instance;

  DiskLruCache _cache;

  factory CacheManager() {
    if (_instance == null) {
      _instance = new CacheManager._();
    }
    return _instance;
  }

  CacheManager._();

  void configCache(String path) {
    _cache = new DiskLruCache(
        maxSize: 10 * 1024 * 1024, directory: new Directory("$path/cache"), filesCount: 1, opCompactThreshold: 200);
  }

  getCacheDirectoryPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  void saveCache(String key, String value) async {
    String path = await getCacheDirectoryPath();
    if (_cache == null) {
      configCache(path);
    }

    var editor = await _cache.edit(key);
    if (editor != null) {
      IOSink sink = await editor.newSink(0);
      try {
        sink.write(value);
      } catch (e) {
        print(e);
      } finally {
        await sink.flush();
        await sink.close();
        await editor.commit();
      }
    }
  }

  Future<String> readCache(String key) async {
    String path = await getCacheDirectoryPath();
    if (_cache == null) {
      configCache(path);
    }

    CacheSnapshot snapshot = await _cache.get(key);
    if (snapshot != null) {
      String cache = await snapshot.getString(0);
      Map<String, dynamic> map = json.decode(cache);
      DateTime nowTime = DateTime.now();
      DateTime cacheTime = DateTime.parse(map["date"]);
      var difference = nowTime.difference(cacheTime);
      if (difference.inHours >= 24) {
        _cache.remove(key);
        return null;
      }
      return cache;
    }
    return null;
  }
}
