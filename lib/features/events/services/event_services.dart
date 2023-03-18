import 'dart:convert';

import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../config/error_handling.dart';
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../providers/user_provider.dart';

class EventServices{
  Future<void> joinEvent(
      {required BuildContext context, required EventModel event}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/join-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"userId": userProvider.user.id, "eventId": event.id}),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print("event joined successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Future<List<User>> getMembers(){
    
  // }
}