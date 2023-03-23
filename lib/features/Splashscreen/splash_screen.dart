import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/features/authentication/screens/login_screen.dart';
import 'package:buddy_go/features/authentication/services/auth_services.dart';
import 'package:buddy_go/features/chat/api/stream_api.dart';
import 'package:buddy_go/features/chat/utils/chat_client.dart';
import 'package:buddy_go/features/home/screens/home_screen.dart';
import 'package:buddy_go/features/Onboarding/screens/choose_avatar_screen.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../models/user_model.dart' as UserModel;

class SplashScreen extends StatefulWidget {
  static const routename = '/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    checkUserData();
    super.initState();
  }

  void checkUserData() async {
    await authService.getUserData(context).then((value) async {
      final UserModel.User user =
          Provider.of<UserProvider>(context, listen: false).user;

      if (user.token.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routename,
          (route) => false,
        );
      } else if (user.imageUrl == '') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChooseAvatarScreen.routename,
          (route) => false,
        );
      } else {
   
        await StreamApi.initUser(
          StreamChat.of(context).client,
          name: '',
          imageUrl: SessionHelper.imageUrl,
          id: SessionHelper.id,
          context: context,
        ).then((value) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routename,
            (route) => false,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
