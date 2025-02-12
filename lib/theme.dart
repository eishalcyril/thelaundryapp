import 'package:flutter/material.dart';

import 'config.dart';

final ThemeData myTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  primaryColorLight: primaryShadeLight,
  primaryColorDark: primaryShadeDark,
  canvasColor: const Color(0xfffafafa),
  scaffoldBackgroundColor: const Color(0xfffafafa),
  cardColor: const Color(0xffffffff),
  dividerColor: const Color(0x1f000000),
  highlightColor: const Color(0x66bcbcbc),
  splashColor: const Color(0x66c8c8c8),
  unselectedWidgetColor: const Color(0x8a000000),
  disabledColor: const Color(0x61000000),
  secondaryHeaderColor: const Color(0xffe0f2f1),
  dialogBackgroundColor: const Color(0xffffffff),
  indicatorColor: primaryShade.shade500,
  hintColor: const Color(0x8a000000),
  buttonTheme: ButtonThemeData(
    padding: const EdgeInsets.only(left: 16, right: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    buttonColor: const Color(0xffe0e0e0),
    disabledColor: const Color(0x61000000),
    highlightColor: const Color(0x29000000),
    splashColor: const Color(0x1f000000),
    focusColor: const Color(0x1f000000),
    hoverColor: const Color(0x0a000000),
    colorScheme: ColorScheme(
      primary: primaryShade,
      secondary: secondaryShade,
      surface: const Color(0xffffffff),
      error: const Color(0xffd32f2f),
      onPrimary: const Color(0xffffffff),
      onSecondary: const Color(0xffffffff),
      onSurface: const Color(0xff000000),
      onError: const Color(0xffffffff),
      brightness: Brightness.light,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xdd000000),
    opacity: 1,
    size: 24,
  ),
  primaryIconTheme: const IconThemeData(
    color: Color(0xffffffff),
    opacity: 1,
    size: 24,
  ),
  sliderTheme: const SliderThemeData(
    valueIndicatorTextStyle: TextStyle(
      color: Color(0xffffffff),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Color(0xffffffff),
    unselectedLabelColor: Color(0xb2ffffff),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Color(0x1f000000),
    brightness: Brightness.light,
    deleteIconColor: Color(0xde000000),
    disabledColor: Color(0x0c000000),
    labelPadding: EdgeInsets.only(left: 8, right: 8),
    labelStyle: TextStyle(
      color: Color(0xde000000),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
    secondaryLabelStyle: TextStyle(
      color: Color(0x3d000000),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color(0x3d009688),
    selectedColor: Color(0x3d000000),
    shape: StadiumBorder(),
  ),
  dialogTheme: const DialogTheme(shape: RoundedRectangleBorder()),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryShade.shade500;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryShade.shade500;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryShade.shade500;
      }
      return null;
    }),
    trackColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryShade.shade500;
      }
      return null;
    }),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xffffffff)),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryShade)
      .copyWith(secondary: secondaryColor)
      .copyWith(surface: primaryShade.shade200)
      .copyWith(error: const Color(0xffd32f2f)),
);
