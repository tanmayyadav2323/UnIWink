import 'dart:convert';
import 'dart:developer';

import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:buddy_go/config/error_handling.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/global_variables.dart';
import '../../../config/utils.dart';

String userId = "";

class AuthService {
  Future<void> authenticateUserPhone(
      {required String phoneNumber, required BuildContext context}) async {
    try {
      User user = User(
        id: '',
        phone: phoneNumber,
      );

      http.Response res = await http.post(
          Uri.parse('$uri/api/authenticatePhone'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          userId = jsonDecode(res.body)["data"]['userId'];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> verifyPhoneNumber(
      {required String otp, required BuildContext context}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/verifyPhone'),
        body: jsonEncode({"otp": otp, "userId": userId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "Phone Number Verified!");
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs
              .setString('x-auth-token', jsonDecode(res.body)['token'])
              .then((value) {});
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get user data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        userProvider.setUser(userRes.body);
      }
      await http.post(Uri.parse('$uri/tokenIsValid'));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
