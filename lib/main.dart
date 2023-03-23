import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/chat/screens/channel_list_page.dart';
import 'package:buddy_go/features/chat/utils/chat_client.dart';
import 'package:buddy_go/features/onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/features/onboarding/screens/choose_avatar_screen.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'config/custom_routes.dart';
import 'features/Onboarding/screens/choose_ai_avatar.dart';
import 'features/splashscreen/splash_screen.dart';
import 'providers/user_provider.dart';

Future main() async {
  // await dotenv.load(fileName: ".env");
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

  final client = StreamChatClient(
    'hqkzqb89kphf',
    logLevel: Level.INFO,
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UniWink',
          theme: ThemeData(
              scaffoldBackgroundColor: backgroundColor,
              iconTheme: IconThemeData(color: Colors.white),
              colorScheme: ColorScheme.dark()),
          initialRoute: SplashScreen.routename,
          builder: (context, child) => StreamChat(
            // streamChatThemeData: StreamChatThemeData(),
            client: client,
            child: child,
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
        );
      },
    );
  }
}
