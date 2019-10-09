import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class YCImageCacheManager extends BaseCacheManager {
  static const key = "YcCachedImageData";

  static YCImageCacheManager _instance;

  factory YCImageCacheManager() {
    if (_instance == null) {
      _instance = new YCImageCacheManager._();
    }
    return _instance;
  }

  YCImageCacheManager._() : super(key, maxNrOfCacheObjects: 400, maxAgeCacheObject: const Duration(days: 365));

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}
