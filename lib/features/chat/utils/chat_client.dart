import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamClient {
  static getClient() {
    return StreamChatClient(
      'hqkzqb89kphf',
      logLevel: Level.SEVERE,
    );
  }
}
