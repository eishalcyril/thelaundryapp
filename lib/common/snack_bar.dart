
import 'package:flutter/material.dart';
import 'package:laundry_app/common/jsonlanguage/mapping_json.dart';
import 'package:laundry_app/enums/response_type_enum.dart';
import 'package:laundry_app/main.dart';


void displaySnackBar(
    {String? message, Color? color, String? type = 'ERROR', int? duration}) {
  String modifiedMessage = modifyMessage(message);

  final Color errorColor = Colors.red[700]!;
  final Color successColor = Colors.green[900]!;
  const Color warningColor = Color.fromARGB(255, 172, 130, 7);
  Color? backgroundColor =
      setBackgroundColor(color, type, errorColor, successColor, warningColor);

  final snackBar = SnackBar(
    width: MediaQueryData.fromView(WidgetsBinding.instance.window).size.width *
        0.90,
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: duration ?? 1000),
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5,
    backgroundColor: backgroundColor,
    content: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                modifiedMessage.toString().replaceAll('<br>', '\n'),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
  rootScaffoldMessengerKey.currentState!.showSnackBar(snackBar);
}

Color? setBackgroundColor(Color? color, String? type, Color errorColor,
    Color successColor, Color warningColor) {
  Color? backgroundColor;
  if (color == null) {
    if (type == ServerResponseType.ERROR.name) {
      backgroundColor = errorColor;
    } else if (type == ServerResponseType.SUCCESS.name) {
      backgroundColor = successColor;
    } else if (type == ServerResponseType.WARNING.name) {
      backgroundColor = warningColor;
    } else if (type == ServerResponseType.MULTI_LINE_WARNING.name) {
      backgroundColor = errorColor;
    }
  } else {
    backgroundColor = color;
  }
  return backgroundColor;
}

String modifyMessage(String? message) {
  String modifiedMessage = "";
  String messageCode;
  List<String> parts = message!.split('.');
  if (parts.length >= 2) {
    messageCode = parts.last;
  } else {
    messageCode = "";
  }
  if (messageCode != "") {
    if (AppConfig.enMapping.containsKey("HTTP_CODE") &&
        AppConfig.enMapping["HTTP_CODE"].containsKey(messageCode)) {
      modifiedMessage = AppConfig.enMapping["HTTP_CODE"][messageCode];
    } else if (AppConfig.enMapping.containsKey("FORM_VALIDATION") &&
        AppConfig.enMapping["FORM_VALIDATION"].containsKey(messageCode)) {
      modifiedMessage = AppConfig.enMapping["FORM_VALIDATION"][messageCode];
    } else {
      modifiedMessage = message;
    }
  } else {
    if (AppConfig.enMapping.containsKey(message)) {
      modifiedMessage = AppConfig.enMapping[message];
    } else {
      modifiedMessage = message;
    }
  }
  return modifiedMessage;
}
