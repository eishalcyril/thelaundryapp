import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/main.dart';

import 'endpoints.dart';

class NewApiService {
  static final NewApiService _instance = NewApiService._internal();
  factory NewApiService() => _instance;

  late final Dio _dio;
  static String userId = '';
  NewApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: '${Endpoints.baseURL}/api/',
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));
  }

  // User APIs
  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'User/Signup',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'address': address,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateAddress({
    required String newAddress,
  }) async {
    try {
      final response =
          await _dio.patch('User/UpdateAddress', // Updated endpoint
              data: {
                'newAddress': newAddress, // Request body
              },
              options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }
  // Future<Map<String, dynamic>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await _dio.post('User/Login',
  //         data: {'email': email, 'password': password},
  //         options: Options(headers: {
  //           'accept': 'text/plain',
  //           'Content-Type': 'application/json'
  //         }));
  //     log('aisjd----${response.data}');
  //     userId = response.data['id'];
  //     return _handleResponse(response);
  //   } on DioException catch (e) {
  //     return _handleDioError(e);
  //   }
  // }

  // Admin APIs
  Future<Map<String, dynamic>> addService({
    required String serviceName,
    required String materialType,
    required double price,
  }) async {
    try {
      final response = await _dio.post(
        'Admin/AddService',
        data: {
          'serviceName': serviceName,
          'materialType': materialType,
          'price': price,
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateService({
    required String id,
    required String serviceName,
    required String materialType,
    required double price,
  }) async {
    try {
      final response = await _dio.put(
        'Admin/Services/$id',
        data: {
          'id': id,
          'serviceName': serviceName,
          'materialType': materialType,
          'price': price,
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Method to delete a service
  Future<Map<String, dynamic>> deleteService(String id) async {
    try {
      final response = await _dio.delete('Admin/Services/$id');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAdminServices() async {
    try {
      final response = await _dio.get('Admin/Services');
      final responseData = _handleResponse(response);
      log(responseData.toString());
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getAdminServiceById({required String id}) async {
    try {
      final response = await _dio.get('Admin/Services/$userId');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAdminOrders() async {
    try {
      final response = await _dio.get('Admin/Orders');
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required int status,
  }) async {
    try {
      final response = await _dio.put(
        'Admin/Orders/$orderId/Status',
        data: status,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Customer APIs
  Future<List<Map<String, dynamic>>> getCustomerServices() async {
    try {
      final response = await _dio.get('Customer/Services',
          options: Options(headers: {"CustomerId": userId}));
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getCustomerServiceById(
      {required String id}) async {
    try {
      final response = await _dio.get('Customer/Services/$userId',
          options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> placeOrder(
      {required Map<String, dynamic> orderData}) async {
    try {
      final response = await _dio.post('Customer/PlaceOrder',
          data: orderData, options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getOrderStatus({required String orderId}) async {
    try {
      final response = await _dio.get('Customer/Orders/$orderId/Status',
          options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    try {
      final response = await _dio.get('Customer/Orders',
          options: Options(headers: {"CustomerId": userId}));
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getCustomerOrderById(
      {required String id}) async {
    try {
      final response = await _dio.get('Customer/Orders/$userId',
          options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateCustomerOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await _dio.put('Customer/Orders/$orderId',
          data: orderData, options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> cancelOrder({required String orderId}) async {
    try {
      final response = await _dio.post('Customer/Orders/$orderId/Cancel',
          options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response,
      {String? requestType}) {
    log(response.toString());
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};
      // Show snackbar only for POST, PUT, PATCH requests
      if (requestType == 'POST' ||
          requestType == 'PUT' ||
          requestType == 'PATCH') {
        showSnackbar(
            response.statusMessage.toString(), response.statusCode ?? 0);
      }
      return {
        'type': 'SUCCESS',
        'data': responseData,
      };
    } else {
      // Show snackbar only for POST, PUT, PATCH requests
      if (requestType == 'POST' ||
          requestType == 'PUT' ||
          requestType == 'PATCH') {
        showSnackbar(
            response.statusMessage.toString(), response.statusCode ?? 0);
      }
      return {
        'type': 'ERROR',
        'message': response.statusMessage ?? 'Unknown error occurred',
        'data': response.data,
      };
    }
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      return {
        'type': 'ERROR',
        'message': e.response?.statusMessage ?? 'Unknown error occurred',
        'data': e.response?.data,
      };
    }

    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
      default:
        errorMessage = 'Network error occurred: ${e.message}';
    }
    print(errorMessage);
    return {
      'type': 'ERROR',
      'message': errorMessage,
      'data': null,
    };
  }

  ////
  ///
  Future<Map<String, dynamic>> post(
      {required String endpoint, dynamic body}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
      );
      userId = response.data['id'];
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // DeliveryAgent APIs
  Future<List<Map<String, dynamic>>> getAvailableOrders() async {
    try {
      final response = await _dio.get('DeliveryAgent/AvailableOrders',
          options: Options(headers: {"UserId": userId}));
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> takeOrder({required String orderId}) async {
    try {
      final response = await _dio.post('DeliveryAgent/TakeOrder/$orderId',
          options: Options(headers: {"UserId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> markDelivered({required String orderId}) async {
    try {
      final response = await _dio.put('DeliveryAgent/MarkDelivered/$orderId',
          options: Options(headers: {"UserId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMyDeliveries() async {
    try {
      final response = await _dio.get('DeliveryAgent/MyDeliveries',
          options: Options(headers: {"UserId": userId}));
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      return [];
    }
  }

  // Admin APIs for User Management
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _dio.get('Admin/Users',
          options: Options(headers: {"UserId": userId}));
      final responseData = _handleResponse(response);
      return responseData['type'] == 'SUCCESS'
          ? List<Map<String, dynamic>>.from(responseData['data']['data'])
          : [];
    } on DioException catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> changeUserType({
    required String userId,
    required int newUserType,
  }) async {
    try {
      final response = await _dio.patch(
        'Admin/ChangeUserType/$userId',
        data: {'newUserType': newUserType},
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Customer Order Review
  Future<Map<String, dynamic>> submitOrderReview({
    required String orderId,
    required Map<String, dynamic> reviewData,
  }) async {
    try {
      final response = await _dio.post('Customer/Orders/$orderId/Review',
          data: reviewData, options: Options(headers: {"CustomerId": userId}));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  void showSnackbar(String message, int statusCode) {
    Color backgroundColor;
    // switch (statusCode) {
    //   case 200: // Success
    //     backgroundColor = Colors.green; // Green for success
    //     break;
    //   case 400: // Bad Request
    //     backgroundColor = Colors.orange; // Orange for client error
    //     break;
    //   case 404: // Not Found
    //     backgroundColor = Colors.red; // Red for not found
    //     break;
    //   case 500: // Server Error
    //     backgroundColor = Colors.redAccent; // Darker red for server error
    //     break;
    //   default:
    //     backgroundColor = Colors.grey; // Default color for other cases
    // }
    if (statusCode >= 200 && statusCode < 300) {
      backgroundColor = Colors.green; // Green for success
    } else if (statusCode >= 400 && statusCode < 500) {
      backgroundColor = Colors.orange; // Orange for client errors
    } else if (statusCode >= 500) {
      backgroundColor = Colors.red; // Red for server errors
    } else {
      backgroundColor = Colors.grey; // Default color for other cases
    }
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
