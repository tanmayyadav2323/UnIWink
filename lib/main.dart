import 'package:buddy_go/features/Authentication/screens/login_screen.dart';
import 'package:buddy_go/features/Home/screens/home_screen.dart';
import 'package:buddy_go/features/Onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/features/Onboarding/screens/choose_avatar_screen.dart';
import 'package:buddy_go/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData(backgroundColor: backgoroundColor),
          home: AboutMeScreen(),
        );
      },
    );
  }
}
