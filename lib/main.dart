import 'package:buddy_go/config/custom_routes.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/home/screens/home_screen.dart';
import 'package:buddy_go/features/onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/features/onboarding/screens/choose_avatar_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'features/Authentication/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UniWink',
          theme: ThemeData(
            backgroundColor: backgroundColor,
            scaffoldBackgroundColor: backgroundColor,
          ),
          initialRoute: LoginScreen.routename,
          onGenerateRoute: CustomRouter.onGenerateRoute,
        );
      },
    );
  }
}
