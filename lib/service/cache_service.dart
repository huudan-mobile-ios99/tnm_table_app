import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:tournament_client/utils/mystring.dart';

class NetworkCache {
  final int _timeOut = 10000; //10 s
  late Dio _dio;
  late CacheConfig cacheConfig = CacheConfig();
  late DioCacheManager _dioCacheManager;

  DioCacheManager get dioCacheManager {
    _dioCacheManager ??= DioCacheManager(CacheConfig(baseUrl: MyString.BASE));
    return _dioCacheManager;
  }

  NetworkCache() {
    BaseOptions options =
        BaseOptions(connectTimeout: _timeOut, receiveTimeout: _timeOut);
    options.baseUrl = MyString.BASE;
    _dio = Dio(options);
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(dioCacheManager.interceptor);
  }

  Future<Response?> get(
      {required String? url,
      Map<String, dynamic>? params,
      Options? options}) async {
    try {
      params ??= {};
      options ??= buildCacheOptions(const Duration(seconds: 60));

      params["api_key"] = MyString.API_KEY;
      return await _dio.get(url!, queryParameters: params, options: options);
    } on DioError catch (e) {
      print("DioError: ${e.toString()}");
    }
    return null;
  }
}
