import 'dart:convert';

import 'package:buddy_go/config/error_handling.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';

class SearchServices {
  Future<List<EventModel>> searchEvents(
      {required BuildContext context, required String search}) async {
    List<EventModel> events = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (search.isEmpty) search = ' ';
      http.Response res = await http.get(
        Uri.parse('$uri/api/search-events/$search'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(res.body);
          try {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              events.add(EventModel.fromJson(jsonEncode(
                jsonDecode(
                  res.body,
                )[i],
              )));
            }
          } catch (e) {
            showSnackBar(context, e.toString());
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return events;
  }
}
