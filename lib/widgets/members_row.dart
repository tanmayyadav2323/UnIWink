import 'package:buddy_go/features/Profile/screens/profile_event_screen.dart';
import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _MembersRowState extends State<MembersRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StreamChat.of(context)
          .client
          .queryChannels(
            state: true,
            watch: true,
            filter: Filter.and([
              Filter.in_('members', [SessionHelper.id]),
              Filter.notExists('channel_type'),
            ]),
          )
          .first,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else {
          List<Channel> channels = [];
          List<User?> members = [];
          if (snapshot.hasData) {
            channels = snapshot.data!;
            if (channels.isEmpty)
              return SizedBox(
                height: 3.h,
              );
            for (final channel in channels) {
              final otherMembers = channel.state!.members
                  .where((m) => m.userId != SessionHelper.id)
                  .map((m) => m.user)
                  .toList();
              members.addAll(otherMembers);
            }
          }

          return Column(
            children: [
              SizedBox(
                height: 3.h,
              ),
              Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: channels.isEmpty
                        ? MediaQuery.of(context).size.width * 0.9
                        : 0,
                    alignment: Alignment.bottomCenter,
                    height: 5.h,
                    child: SizedBox(
                      width: 50.w,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: channels.isNotEmpty
                        ? MediaQuery.of(context).size.width * 0.9
                        : 0,
                    height: 7.h,
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
                                    builder: (_) =>
                                        ProfileScreen(id: members[index]!.id)),
                              );
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 4.5.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      members[index]!.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.5.h,
                                  right: 2.5.w,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xff0D0E34),
                                    radius: 0.75.h,
                                    child: CircleAvatar(
                                      radius: 0.50.h,
                                      backgroundColor: members[index]!.online
                                          ? Color(0xff00AE31)
                                          : Color(0xffAE0000),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          );
        }

        return SizedBox(
          height: 3.h,
        );
      },
    );
  }
}
