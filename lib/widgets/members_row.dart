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
            filter: Filter.in_(
              'members',
              [SessionHelper.id],
            ),
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
                    duration: Duration(milliseconds: 1000),
                    width: channels.isEmpty
                        ? MediaQuery.of(context).size.width * 0.9
                        : 0,
                    alignment: Alignment.bottomCenter,
                    height: 5.h,
                    child: SizedBox(
                      width: 50.w,
                      child: Text(
                        "No Winks  🙁",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
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
                                    radius: 5,
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
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
