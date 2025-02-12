import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:laundry_app/common/network/endpoints.dart';


import 'interceptors/interceptors.dart';

class DioClient {
  factory DioClient() {
    return _singleton;
  }
  DioClient._internal();
  static final DioClient _singleton = DioClient._internal();

  static final Dio client = createDioClient();

  static Dio createDioClient() {
    return Dio(
      BaseOptions(
          baseUrl: Endpoints.baseURL, contentType: Headers.jsonContentType),
    )..interceptors.addAll([
        AuthorizationInterceptor(),
        if (kDebugMode) LoggerInterceptor(),
      ]);
  }
}
