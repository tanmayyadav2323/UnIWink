import 'package:buddy_go/config/custom_routes.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Splashscreen/splash_screen.dart';
import 'package:buddy_go/features/home/screens/home_screen.dart';
import 'package:buddy_go/features/onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/features/onboarding/screens/choose_avatar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'features/Authentication/screens/login_screen.dart';
import 'features/Authentication/services/auth_services.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

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
          initialRoute: SplashScreen.routename,
          onGenerateRoute: CustomRouter.onGenerateRoute,
        );
      },
    );
  }
}
