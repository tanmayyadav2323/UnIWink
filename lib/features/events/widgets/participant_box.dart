import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:flutter/material.dart';

import 'package:buddy_go/models/user_model.dart' as UserModel;
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../models/wink_model.dart';
import '../../chat/api/stream_api.dart';
import '../../chat/screens/channel_page.dart';

enum WinkBoxStatus {
  winkById,
  winkToId,
  unWinked,
  accepted,
  none,
}

class ParticipantBox extends StatefulWidget {
  final UserModel.User user;
  const ParticipantBox({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ParticipantBox> createState() => _ParticipantBoxState();
}

class _ParticipantBoxState extends State<ParticipantBox> {
  WinkBoxStatus status = WinkBoxStatus.none;
  late UserModel.User user;
  final eventService = EventServices();
  late WinkModel winkModel;

  @override
  void initState() {
    user = widget.user;
    List<dynamic> winks = user.winks;

    for (int i = 0; i < winks.length; i++) {
      if (winks[i]['winkedToId'] == SessionHelper.id ||
          winks[i]['winkedById'] == SessionHelper.id) {
        winkModel = WinkModel.fromMap(winks[i]);
        if (winkModel.status == WinkStatus.winked) {
          if (winks[i]['winkedById'] == SessionHelper.id) {
            status = WinkBoxStatus.winkById;
          } else {
            status = WinkBoxStatus.winkToId;
          }
        } else if (winkModel.status == WinkStatus.accepted) {
          status = WinkBoxStatus.accepted;
        } else if (winkModel.status == WinkStatus.unwinked) {
          status = WinkBoxStatus.unWinked;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              height: 8.h,
              width: 8.h,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0XFFFF005C),
                    Color(0XFFFFFFFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w),
                child: Image.network(
                  user.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Flexible(
              child: Text(
                '"${user.des}"',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        if (user.id != SessionHelper.id) getStatus(status),
        SizedBox(
          height: 1.h,
        ),
        const Divider(
          color: Colors.white,
          thickness: 0.2,
        )
      ],
    );
  }

  Widget getStatus(WinkBoxStatus winkBoxStatus) {
    switch (winkBoxStatus) {
      case WinkBoxStatus.winkById:
        return InkWell(
          onTap: () async {
            await eventService.updateWink(
                context: context,
                winkId: winkModel.id!,
                status: WinkStatus.unwinked.index);
            setState(() {
              status = WinkBoxStatus.unWinked;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFF005C),
            ),
            child: Text(
              "Winked",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
      case WinkBoxStatus.winkToId:
        return Row(
          children: [
            InkWell(
              onTap: () async {
                await eventService.updateWink(
                    context: context,
                    winkId: winkModel.id!,
                    status: WinkStatus.accepted.index);
                final channel = StreamChat.of(context).client.channel(
                      'messaging',
                      extraData: {
                        'members': [SessionHelper.id, widget.user.id],
                        'u1id': SessionHelper.id,
                        'u2id': widget.user.id,
                      },
                      id: StreamApi.generateChannelId(
                        SessionHelper.id,
                        widget.user.id,
                      ),
                    );
                await channel.watch();
                setState(() {
                  status = WinkBoxStatus.accepted;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0XFFFF005C),
                ),
                child: Text(
                  "Accept",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await eventService.updateWink(
                    context: context,
                    winkId: winkModel.id!,
                    status: WinkStatus.unwinked.index);
                setState(() {
                  status = WinkBoxStatus.unWinked;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0XFFFF005C),
                ),
                child: Text(
                  "Reject",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            )
          ],
        );
      case WinkBoxStatus.unWinked:
        return InkWell(
          onTap: () async {
            await eventService.updateWink(
                context: context,
                winkId: winkModel.id!,
                status: WinkStatus.winked.index);
            setState(() {
              status = WinkBoxStatus.winkById;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFF005C),
            ),
            child: Text(
              "Wink",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
      case WinkBoxStatus.accepted:
        return InkWell(
          onTap: () async {
            final client = StreamChat.of(context).client;
            final channel = await client
                .queryChannels(
                  state: true,
                  watch: true,
                  filter: Filter.in_(
                    'members',
                    [widget.user.id, SessionHelper.id],
                  ),
                )
                .first;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  key: ValueKey(channel.first.cid),
                  channel: channel.first,
                  child: const ChannelPage(),
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFF005C),
            ),
            child: Text(
              "Chat",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
      case WinkBoxStatus.none:
        return InkWell(
          onTap: () async {
            await eventService.wink(context: context, winkToId: widget.user.id);
            setState(() {
              status = WinkBoxStatus.winkById;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFF005C),
            ),
            child: Text(
              "Wink",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
    }
  }
}
