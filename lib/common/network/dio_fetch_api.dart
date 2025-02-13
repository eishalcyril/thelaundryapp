import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:laundry_app/common/network/dio_client.dart';
import 'package:laundry_app/common/network/dio_exception.dart';
import 'package:laundry_app/common/snack_bar_service.dart';
import 'package:laundry_app/enums/response_type_enum.dart';

class FetchApi {
  factory FetchApi() {
    return _singleton;
  }

  FetchApi._internal();

  static final FetchApi _singleton = FetchApi._internal();

  static Future<dynamic> getData({
    required String endPoint,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.get(endPoint,
          options: Options(
            headers: headers,
            extra: {'requiresToken': requiresToken},
          ));

      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<dynamic> postData({
    required String endPoint,
    Map? body,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        options: Options(
          headers: headers,
          extra: {'requiresToken': requiresToken},
        ),
        data: jsonEncode(body),
      );
      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  static dynamic decodeResponse(dynamic response) {
    try {
      final dynamic resultJson;
      // some times response may be json
      if (!(response.runtimeType == String)) {
        final result = jsonEncode(response);
        resultJson = jsonDecode(result);
      } else {
        resultJson = jsonDecode(response);
      }
      // if(resultJson['type'])
      if (SnackBarService.checkResponseType(resultJson)) {
        Map responseData = resultJson['responseData'] ?? {};

        List messageList = responseData['message'] ?? [];
        if (messageList.isNotEmpty) {
          String concatenatedMessages = '';

          for (var element in messageList) {
            concatenatedMessages = element.values.map((map) => map).join('\n');
          }
          SnackBarService.showSnackBar(
              concatenatedMessages, resultJson['type']);
        }
        if ((resultJson['redirect'] ?? false) &&
            resultJson['type'] == ServerResponseType.ERROR.name) {
          // Get.offAll(() => const LoginForm());
          SnackBarService.showSnackBar(
              resultJson['message'], resultJson['type']);
        }
      }
      return resultJson;
    } on Exception catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<dynamic> postFormData({
    required String endPoint,
    required FormData formData,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
          extra: {'requiresToken': requiresToken},
        ),
        data: formData,
      );

      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  static Future<Uint8List?> fetchDataFromBlob({
    required String endPoint,
    Map? body,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        data: jsonEncode(body),
        options: Options(
          responseType: ResponseType.bytes,
          // contentType: 'image/jpg',
          extra: {'requiresToken': requiresToken},
        ),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        if (response.headers['Content-type']![0].contains('application/json')) {
          String jsonString = utf8.decode(responseData);
          Map<String, dynamic> jsonData = jsonDecode(jsonString);

          if (SnackBarService.checkResponseType(jsonData)) {
            Map responseData = jsonData['responseData'] ?? {};

            List messageList = responseData['message'] ?? [];
            if (messageList.isNotEmpty) {
              String concatenatedMessages = '';

              for (var element in messageList) {
                concatenatedMessages =
                    element.values.map((map) => map).join('\n');
              }
              SnackBarService.showSnackBar(
                  concatenatedMessages, jsonData['type']);
            }
            if ((jsonData['redirect'] ?? false) &&
                jsonData['type'] == ServerResponseType.ERROR.name) {
              // Get.offAll(() => const LoginForm());
              SnackBarService.showSnackBar(
                  jsonData['message'], jsonData['type']);
            }
          }
          // return jsonData;
          throw DioBlobException(jsonString);
        } else {
          if (responseData is Uint8List) {
            return responseData;
          } else if (responseData is String) {
            return Uint8List.fromList(responseData.codeUnits);
          } else {
            throw Exception('Unexpected response type');
          }
        }
      }
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
    return null;
  }
}
