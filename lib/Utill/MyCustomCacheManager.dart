import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCustomCacheManager {
  static const key = "myCustomCache";

  static final MyCustomCacheManager _instance = MyCustomCacheManager._internal();

  factory MyCustomCacheManager() => _instance;

  late final CacheManager manager;

  MyCustomCacheManager._internal() {
    manager = CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 30),
        maxNrOfCacheObjects: 200,
       // maxSize: 512 * 1024 * 1024, // 512 MB
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
  }
}
