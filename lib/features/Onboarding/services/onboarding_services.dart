import 'dart:io';

import 'package:buddy_go/config/assest_to_file.dart';
import 'package:buddy_go/config/error_handling.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../models/user_model.dart';
import '../../splashscreen/splash_screen.dart';

class OnBoardingServices {
  Future<void> setUpAccount(
      {required BuildContext context,
      required User user,
      required String imagePath}) async {
    try {
      final cloudinary = CloudinaryPublic('dskknaiy3', 'i4y0ahjg');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      File imageFile = await getImageFileFromAssets(imagePath);

      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: "UnIWink"),
      );

      final updateUser = user.copyWith(imageUrl: cloudinaryResponse.secureUrl);
      http.Response res = await http.post(
        Uri.parse('$uri/api/update-user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: updateUser.toJson(),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          userProvider.setUserFromModel(updateUser);
          Navigator.pushNamedAndRemoveUntil(
            context,
            SplashScreen.routename,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
