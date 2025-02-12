import 'package:flutter/material.dart';
import 'package:laundry_app/common/defaultpage.dart';
import 'package:laundry_app/login_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
//################  DASHBOARD  ################//

      case '/':
        return MaterialPageRoute(
          builder: (_) => const LoginForm(),
        );

//################  DEFAULT  ################//

      default:
        return MaterialPageRoute(
          builder: (_) => const Default(),
        );
    }
  }
}
