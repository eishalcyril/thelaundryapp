import 'dart:developer' as developer;

import '../network/dio_fetch_api.dart';

class CustomerSearch {
  static Future<List<Map<String, String>>> getSuggestions(
    String selectedSearchProperty,
    String selectedValue,
    String url,
  ) async {
    if (selectedValue.isEmpty) return [];
    try {
      Map body = {
        'admittedOn_DateTime': "",
        'patientStatus_Text': "Admitted",
        'selectedSearchProperty_Text': selectedSearchProperty,
        'selectedValue_Text': selectedValue
      };
      final response = await FetchApi.postData(endPoint: url, body: body);
      developer.log('', error: response.toString());
      if (response == null) {
        return [];
      }

      if (response.runtimeType == List) {
        List<Map<String, String>> patientDetails = [];
        for (Map object in response) {
          object.updateAll((key, value) => value.toString());
          patientDetails.add(Map<String, String>.from(object));
        }
        return patientDetails;
      }

      if (response['responseData'] != null) {
        List<Map<String, String>> patientDetails = [];
        for (Map object in response['responseData']) {
          object.updateAll((key, value) => value.toString());
          patientDetails.add(Map<String, String>.from(object));
        }
        return patientDetails;
      }
      return [];
    } on Exception catch (e) {
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
      return [];
    }
  }
  
}


