import 'package:buddy_go/features/Authentication/screens/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../features/Authentication/screens/login_screen.dart';
import '../features/Splashscreen/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const SplashScreen(),
        );
      case LoginScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routename),
          builder: (_) =>  LoginScreen(),
        );
          case VerifyPhoneNumberScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routename),
          builder: (_) =>  VerifyPhoneNumberScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
