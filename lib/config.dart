import 'package:flutter/material.dart';

import 'common/color_generator.dart';

//  ###########  Colors ########## //

Color primaryColor = Colors.blueGrey;
Color txtColor = Colors.white;
Color sectxtColor = Colors.black54;
Color secondaryColor = const Color.fromARGB(255, 4, 116, 130);

MaterialColor primaryShade = generateMaterialColor(primaryColor);
MaterialColor primaryShadeLight = generateMaterialColor(primaryShade.shade50);
MaterialColor primaryShadeDark = generateMaterialColor(primaryShade.shade900);

MaterialColor secondaryShade = generateMaterialColor(secondaryColor);
MaterialColor secondaryShadeLight =
    generateMaterialColor(secondaryShade.shade50);
MaterialColor secondaryShadeDark =
    generateMaterialColor(secondaryShade.shade900);

// ########
final double shortSide =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide;
final double longestSide =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.longestSide;

final double scaleFactor = shortSide < 600
    ? 1
    : shortSide < 800
        ? 1.4
        : 1.6;
