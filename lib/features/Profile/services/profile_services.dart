import 'dart:convert';

import 'package:buddy_go/config/error_handling.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../models/event_model.dart';

class ProfielServices {
  Future<List<EventModel>> getUserEvents(
      {required BuildContext context, required String userId}) async {
    List<EventModel> events = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(Uri.parse('$uri/api/user-event'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            "userId": userId,
          }));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              events.add(EventModel.fromJson(jsonEncode(
                jsonDecode(
                  res.body,
                )[i],
              )));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return events;
  }

  Future<User?> getUser(
      {required BuildContext context, required String userId}) async {
    User? user;
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(Uri.parse('$uri/api/get-user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            "userId": userId,
          }));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            user = User.fromJson(jsonEncode(jsonDecode(res.body)));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return user;
  }
}
