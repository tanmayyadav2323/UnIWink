// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../chat/screens/channel_page.dart';

class EventChannelScreen extends StatefulWidget {
  final String eventId;
  const EventChannelScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<EventChannelScreen> createState() => _EventChannelScreenState();
}

class _EventChannelScreenState extends State<EventChannelScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StreamChat.of(context)
            .client
            .queryChannels(
              state: true,
              watch: true,
              filter: Filter.in_(
                'id',
                [widget.eventId],
              ),
            )
            .first,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showSnackBar(context, snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<String> members = [];
            if (snapshot.data!.isEmpty) return SizedBox.shrink();
            Channel channel = snapshot.data![0];
            return StreamChannel(
              key: ValueKey(channel.cid),
              channel: channel,
              child: const ChannelPage(
                showBackButton: false,
              ),
            );
          }
          return const Text("no data");
        });
  }
}
