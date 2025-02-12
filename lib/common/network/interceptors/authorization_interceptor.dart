import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

//* Request methods which needs access token have to be passed
//* with "X-Auth-AccessToken" header as accesstoken.
class AuthorizationInterceptor extends Interceptor {
  Box box = Hive.box('laundry');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['requiresToken'] ?? false) {
      String? accessToken = box.get('accesstoken');
      Map<String, dynamic> headers = {'X-Auth-AccessToken': accessToken};
      accessToken == null ? Get.toNamed('/') : options.headers.addAll(headers);
    }

    super.onRequest(options, handler);
  }
}
