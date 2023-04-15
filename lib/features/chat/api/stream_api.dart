import 'package:buddy_go/config/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class StreamApi {
  static Future initUser(
    StreamChatClient client, {
    required String name,
    required String imageUrl,
    required String id,
    required BuildContext context,
  }) async {
    await StreamChat.of(context).client.disconnectUser();
    await tokenProvider(SessionHelper.id).then((value) async {
      var user = User(
        id: SessionHelper.id,
        image: SessionHelper.imageUrl,
        name: SessionHelper.imageUrl,
      );
      await client.connectUser(user, value);
    });
  }

  static Future<String> tokenProvider(String id) async {
    final jwt = JWT(
      {'user_id': id},
    );
    var token = jwt.sign(
        SecretKey(
            'yskp856s4a5b3fnxrduq4rqd6kat8qu6vznffkfujv6yrh7247gp4p952yu5jn8s'),
        algorithm: JWTAlgorithm.HS256);
    return token;
  }

  static Future<Channel> createChannel(
    StreamChatClient client, {
    required String type,
    required String id,
    required String name,
    required String image,
    List<String> idMembers = const [],
  }) async {
    final channel = client.channel(type,
        id: id,
        extraData: {'name': name, 'image': image, 'members': idMembers});
    await channel.create();
    channel.watch();
    return channel;
  }

  static Future<Channel> watchChannel(
    StreamChatClient client, {
    required String type,
    required String id,
  }) async {
    final channel = client.channel(type, id: id);
    channel.watch();
    return channel;
  }

  static String generateChannelId(
      String senderUsername, String receiverUsername) {
    List<String> ids = [senderUsername, receiverUsername];
    ids.sort();
    return ids.join();
  }
}
