import 'dart:convert';
import 'dart:developer';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:buddy_go/models/wink_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sc;

import '../../../config/error_handling.dart';
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../providers/user_provider.dart';

class EventServices {
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
        body: jsonEncode({
          "userId": userProvider.user.id,
          "eventId": event.id,
          "imageUrl": userProvider.user.imageUrl,
        }),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final client = sc.StreamChat.of(context).client;

          final channel = client.channel('messaging', id: event.id);
          channel.addMembers([SessionHelper.id]);
          await channel.watch();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> reportEvent(
      {required BuildContext context,
      required String eventId,
      required String message}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/report-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "userId": userProvider.user.id,
          "eventId": eventId,
          "message": message,
        }),
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

  Future<void> deleteEvent({
    required BuildContext context,
    required String eventId,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/delete-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "eventId": eventId,
        }),
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

  Future<void> leaveEvent({
    required BuildContext context,
    required String eventId,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/leave-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "eventId": eventId,
          "userId": userProvider.user.id,
          "imageUrl": userProvider.user.imageUrl,
        }),
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

  Future<void> rateEvent(
      {required BuildContext context,
      required String eventId,
      required double rateValue}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "eventId": eventId,
          "userId": userProvider.user.id,
          "rateValue": rateValue,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<double> getRating({
    required BuildContext context,
    required String eventId,
  }) async {
    double ans = 0;
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/get-event-rating'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "eventId": eventId,
          "userId": userProvider.user.id,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          if (jsonDecode(res.body) == null) {
          } else {
            ans = double.parse(jsonDecode(res.body)['rate'].toString());
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return ans;
  }

  Future<List<User>> getMembers(
      {required BuildContext context, required List<String> members}) async {
    List<User> users = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/event-users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"userIds": members}),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            users.add(User.fromJson(jsonEncode(
              jsonDecode(
                res.body,
              )[i],
            )));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    log(users.toString());
    return users;
  }

  Future<void> wink(
      {required BuildContext context,
      required String winkToId,
      required String message}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/wink-user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: WinkModel(
          winkedById: userProvider.user.id,
          status: WinkStatus.winked,
          winkedToId: winkToId,
          message: message,
        ).toJson(),
      );
      // ignore: use_build_context_synchronously
      log("wink message ${res.body}");
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateWink({
    required BuildContext context,
    required String winkId,
    required int status,
    required String message,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/update-wink'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "winkId": winkId,
          "status": status,
          "message": message,
        }),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
