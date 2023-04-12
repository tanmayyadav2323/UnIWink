import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:buddy_go/config/assest_to_file.dart';
import 'package:buddy_go/config/global_variables.dart';
import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:buddy_go/config/error_handling.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sc;

import '../../chat/api/stream_api.dart' as streamApi;

class HomeServices {
  Future<void> editEvent({
    required String? id,
    required BuildContext context,
    required String title,
    required String about,
    required DateTime startDate,
    required DateTime endDate,
    required String organizer,
    required XFile profileImage,
    required List<XFile> images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dskknaiy3', 'i4y0ahjg');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String pfImage = "";
      List<String> eventImages = [];

      CloudinaryResponse pfRes = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(profileImage.path, folder: "UnIWink"),
      );

      pfImage = pfRes.secureUrl;

      for (var image in images) {
        CloudinaryResponse imgRes = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "UnIWink"),
        );
        eventImages.add(imgRes.secureUrl);
      }

      EventModel event = EventModel(
        id: id,
        title: title,
        authorId: userProvider.user.id,
        memberIds: [],
        creationDate: DateTime.now(),
        about: about,
        memberImageUrls: [userProvider.user.imageUrl],
        organizer: organizer,
        savedMembers: [],
        image: pfImage,
        images: eventImages,
        rating: 0,
        startDateTime: startDate,
        endDateTime: endDate,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/edit-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: event.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print("success");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> createEvent({
    required BuildContext context,
    required String title,
    required String about,
    required DateTime startDate,
    required DateTime endDate,
    required String organizer,
    required XFile profileImage,
    required List<XFile> images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dskknaiy3', 'i4y0ahjg');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String pfImage = "";
      List<String> eventImages = [];

      CloudinaryResponse pfRes = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(profileImage.path, folder: "UnIWink"),
      );

      pfImage = pfRes.secureUrl;

      for (var image in images) {
        CloudinaryResponse imgRes = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "UnIWink"),
        );
        eventImages.add(imgRes.secureUrl);
      }

      EventModel event = EventModel(
        title: title,
        authorId: userProvider.user.id,
        memberIds: [],
        creationDate: DateTime.now(),
        about: about,
        memberImageUrls: [userProvider.user.imageUrl],
        organizer: organizer,
        savedMembers: [],
        image: pfImage,
        images: eventImages,
        rating: 0,
        startDateTime: startDate,
        endDateTime: endDate,
      );
      http.Response res = await http.post(
        Uri.parse('$uri/api/create-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: event.toJson(),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final event = EventModel.fromJson(jsonEncode(jsonDecode(
            res.body,
          )));

          final channel = sc.StreamChat.of(context).client.channel(
                'messaging',
                extraData: {
                  'members': [SessionHelper.id],
                  "channel_type": "group",
                  'name': event.title,
                  "admin": SessionHelper.id,
                  "image": event.image,
                  'permissions': {
                    'read': ['user:*'],
                    'write': ['user:*'],
                    'addMembers': ['user:*'],
                    'manageMembers': [SessionHelper.id],
                  },
                },
                id: event.id,
              );
          channel.addMembers([SessionHelper.id]);
          await channel.watch();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<EventModel>> getOngoingEvents({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/ongoing-events'),
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

  Future<List<EventModel>> upComingEvents({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/upcoming-events'),
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

  Future<List<User>> winkMembers({required BuildContext context}) async {
    List<User> users = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/user-winks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"userId": userProvider.user.id}),
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

    return users;
  }

  Future<List<EventModel>> getAllPastEvents({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/past-events'),
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
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            events.add(EventModel.fromJson(jsonEncode(
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

    return events;
  }

  Future<List<EventModel>> getJoinedEvents({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/joined-events/${userProvider.user.id}'),
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
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            events.add(EventModel.fromJson(jsonEncode(
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

    return events;
  }

  Future<List<EventModel>> getMyEvents({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/my-events/${userProvider.user.id}'),
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
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            events.add(EventModel.fromJson(jsonEncode(
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

    return events;
  }

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

  Future<void> saveEvent(
      {required BuildContext context,
      required String eventId,
      required bool add}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-event'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
            {"userId": userProvider.user.id, "eventId": eventId, "add": add}),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print("event saved successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<EventModel>> getSavedEvent({
    required BuildContext context,
  }) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('$uri/api/saved-events/${userProvider.user.id}'),
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
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            events.add(EventModel.fromJson(jsonEncode(
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

    return events;
  }

  Future<List<EventModel>> updateUser(
      {required BuildContext context,
      required User user,
      String? imagePath}) async {
    List<EventModel> events = [];

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (imagePath != null) {
        File imageFile = await getImageFileFromAssets(imagePath);

        final cloudinary = CloudinaryPublic('dskknaiy3', 'i4y0ahjg');
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(imageFile.path, folder: "UnIWink"),
        );

        user = user.copyWith(imageUrl: cloudinaryResponse.secureUrl);
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/update-user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: user.toJson(),
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

    return events;
  }
}
