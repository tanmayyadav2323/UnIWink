import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../config/session_helper.dart';
import '../config/utils.dart';
import '../features/chat/screens/channel_page.dart';

class MembersRow extends StatefulWidget {
  const MembersRow({super.key});

  @override
  State<MembersRow> createState() => _MembersRowState();
}

class _MembersRowState extends State<MembersRow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StreamChat.of(context)
          .client
          .queryChannels(
            state: true,
            watch: true,
            filter: Filter.in_(
              'members',
              [SessionHelper.id],
            ),
          )
          .first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          var channels = snapshot.data!;
          List<User?> members = [];

          for (final channel in channels) {
            final otherMembers = channel.state!.members
                .where((m) => m.userId != SessionHelper.id)
                .map((m) => m.user)
                .toList();
            members.addAll(otherMembers);
          }
          if (channels == null || channels.isEmpty) return SizedBox.shrink();
          return Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              const Divider(
                color: Colors.white,
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: members.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StreamChannel(
                                key: ValueKey(channels[index].cid),
                                channel: channels[index],
                                child: const ChannelPage(),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  members[index]!.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 15,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: members[index]!.online
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              const Divider(
                color: Colors.white,
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}