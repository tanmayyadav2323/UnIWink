import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/maps/place_scren.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'config/custom_routes.dart';
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
            scrollbarTheme: ScrollbarThemeData(
                thumbColor: MaterialStatePropertyAll(Colors.transparent),
                trackColor: MaterialStatePropertyAll(Colors.transparent),
                trackBorderColor: MaterialStatePropertyAll(Colors.transparent)),
            scaffoldBackgroundColor: backgroundColor,
            iconTheme: IconThemeData(color: Colors.white),
            colorScheme: ColorScheme.dark(),
          ),
          themeMode: ThemeMode.dark,
          initialRoute: SplashScreen.routename,
          builder: (context, child) => ScrollConfiguration(
            behavior: MyBehavior(),
            child: StreamChat(
              // streamChatThemeData: StreamChatThemeData(),
              client: client,
              child: child,
            ),
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
        );
        //   home: ProfileScreen(),
        // );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
