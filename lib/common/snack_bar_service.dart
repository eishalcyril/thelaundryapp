
import 'dart:developer' as developer;

import 'package:laundry_app/common/snack_bar.dart';
import 'package:laundry_app/enums/response_type_enum.dart';

class SnackBarService {
  /*
   * Check ResponseType to Show snack bar
   */

  static bool checkResponseType(dynamic resultJson) {
    try {
      if (resultJson.runtimeType == List<dynamic>) {
        return false;
      }

      String? responseType = resultJson['type'] ?? '';

      if (responseType!.isNotEmpty &&
          (responseType == ServerResponseType.SUCCESS.name ||
              responseType == ServerResponseType.ERROR.name ||
              responseType == ServerResponseType.MULTI_LINE_WARNING.name ||
              responseType == ServerResponseType.WARNING.name)) {
        return true;
      }

      return false;
    } on Exception catch (e) {
      developer.log(
        e.toString(),
      );
      return false;
    }
  }

  static void showSnackBar(String message, String type) {
    displaySnackBar(
      message: message,
      type: type,
    );
  }
}
