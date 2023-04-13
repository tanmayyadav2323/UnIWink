import 'dart:ui';

import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/maps/dummy_map_screen.dart';
import 'package:buddy_go/features/maps/map_screen.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'config/custom_routes.dart';
import 'features/splashscreen/splash_screen.dart';
import 'providers/user_provider.dart';

Future main() async {
  // await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        )
      ],
      child: DevicePreview(
          enabled: true,
          tools: [
            ...DevicePreview.defaultTools,
          ],
          builder: (context) {
            return const MyApp();
          })));
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
          home: MapScreen(),
        );
        //   initialRoute: SplashScreen.routename,
        //   builder: (context, child) => ScrollConfiguration(
        //     behavior: MyBehavior(),
        //     child: StreamChat(
        //       streamChatThemeData: StreamChatThemeData(
        //         colorTheme: StreamColorTheme.dark(),
        //         brightness: Brightness.dark,
        //         messageListViewTheme: StreamMessageListViewThemeData(
        //           backgroundColor: backgroundColor,
        //         ),
        //         messageInputTheme: StreamMessageInputThemeData(
        //           inputBackgroundColor: backgroundColor,
        //           actionButtonColor: Colors.white,
        //           borderRadius: BorderRadius.circular(10),
        //           inputTextStyle: GoogleFonts.poppins(
        //             fontSize: 12.sp,
        //             fontWeight: FontWeight.w400,
        //           ),
        //           idleBorderGradient: LinearGradient(colors: [
        //             Colors.white.withOpacity(0.5),
        //             Colors.white.withOpacity(0.5)
        //           ]),
        //           activeBorderGradient: LinearGradient(colors: [
        //             Colors.white.withOpacity(0.5),
        //             Colors.white.withOpacity(0.5)
        //           ]),
        //           sendButtonColor: Colors.blue,
        //           sendButtonIdleColor: Colors.white.withOpacity(0.5),
        //           actionButtonIdleColor: Colors.white.withOpacity(0.5),
        //           inputDecoration: InputDecoration(
        //             fillColor: backgroundColor,
        //             focusColor: backgroundColor,
        //             hintText: "Type Message...",
        //             hintStyle: GoogleFonts.poppins(
        //               fontSize: 10.sp,
        //               color: Colors.white.withOpacity(0.5),
        //             ),
        //             border: OutlineInputBorder(
        //               borderSide: BorderSide(color: Colors.white, width: 2),
        //               borderRadius: BorderRadius.horizontal(
        //                 right: Radius.circular(10),
        //                 left: Radius.circular(10),
        //               ),
        //             ),
        //           ),
        //         ),
        //         channelHeaderTheme: StreamChannelHeaderThemeData(),
        //         textTheme: StreamTextTheme.dark(
        //           body: GoogleFonts.poppins(
        //             fontSize: 10.sp,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         ownMessageTheme: StreamMessageThemeData(
        //           messageBackgroundColor: Color(0xff272A70),
        //           avatarTheme: StreamAvatarThemeData(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         ),
        //         otherMessageTheme: StreamMessageThemeData(
        //           messageBackgroundColor: Color(0xffB70450),
        //           avatarTheme: StreamAvatarThemeData(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         ),
        //       ),
        //       client: client,
        //       child: child,
        //     ),
        //   ),
        //   onGenerateRoute: CustomRouter.onGenerateRoute,
        // );
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
