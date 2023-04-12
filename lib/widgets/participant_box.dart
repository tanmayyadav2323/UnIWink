import 'dart:math';

import 'package:buddy_go/config/global_variables.dart';
import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:buddy_go/models/user_model.dart' as UserModel;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../models/wink_model.dart';
import '../features/chat/api/stream_api.dart';
import '../features/chat/screens/channel_page.dart';

enum WinkBoxStatus {
  winkById,
  winkToId,
  unWinked,
  accepted,
  none,
}

class ParticipantBox extends StatefulWidget {
  final UserModel.User user;
  final bool dividerOff;
  const ParticipantBox({
    Key? key,
    required this.user,
    this.dividerOff = false,
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
    winkModel = WinkModel.empty();
    for (int i = 0; i < winks.length; i++) {
      winkModel = WinkModel.fromMap(winks[i]);
      if (winks[i]['winkedToId'] == SessionHelper.id ||
          winks[i]['winkedById'] == SessionHelper.id) {
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
            if (status == WinkBoxStatus.winkToId)
              Stack(
                children: [
                  Container(
                    height: 8.h,
                    width: 8.h,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: (user.id != SessionHelper.id)
                          ? LinearGradient(
                              colors: [
                                Color(0XFFFF005C),
                                Color(0XFFFFFFFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Image.network(
                        user.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (user.id != SessionHelper.id)
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: backgroundColor,
                          radius: 1.2.h,
                          child: SvgPicture.asset(
                            "assets/icons/wink_img.svg",
                          ),
                        ))
                ],
              ),
            if (status != WinkBoxStatus.winkToId)
              SizedBox(
                height: 8.h,
                width: 8.h,
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
        if (widget.dividerOff == false)
          Divider(
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
              status: WinkStatus.unwinked.index,
              message: winkModel.message,
            );
            setState(() {
              status = WinkBoxStatus.unWinked;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFB70450),
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
        return Column(
          children: [
            if (winkModel.message.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message : ",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Text(
                          winkModel.message,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () async {
                    String randomName1 =
                        randomNames[Random().nextInt(randomNames.length)];
                    String randomName2 =
                        randomNames[Random().nextInt(randomNames.length)];

                    await eventService.updateWink(
                        context: context,
                        winkId: winkModel.id!,
                        message: winkModel.message,
                        status: WinkStatus.accepted.index);
                    final channel = StreamChat.of(context).client.channel(
                          'messaging',
                          extraData: {
                            'members': [SessionHelper.id, widget.user.id],
                            'u1id': SessionHelper.id,
                            'u2id': widget.user.id,
                            '${SessionHelper.id}_name': randomName1,
                            '${widget.user.id}_name': randomName2,
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
                    padding: EdgeInsets.all(0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xffB70450)),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Color(0xffB70450),
                      size: 3.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                InkWell(
                  onTap: () async {
                    await eventService.updateWink(
                        context: context,
                        message: winkModel.message,
                        winkId: winkModel.id!,
                        status: WinkStatus.unwinked.index);
                    setState(() {
                      status = WinkBoxStatus.unWinked;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 3.h,
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      case WinkBoxStatus.unWinked:
        return InkWell(
          onTap: () async {
            final TextEditingController _textEditingController =
                TextEditingController(text: winkModel.message);
            showDialog(
              context: context,
              barrierColor: backgroundColor,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: backgroundColor,
                  title: Text('Send Connection Message'),
                  content: TextField(
                    controller: _textEditingController,
                  ),
                  actions: [
                    InkWell(
                      onTap: () async {
                        await eventService.updateWink(
                          context: context,
                          winkId: winkModel.id!,
                          message: _textEditingController.text,
                          status: WinkStatus.winked.index,
                        );
                        setState(() {
                          status = WinkBoxStatus.winkById;
                        });
                      },
                      child: Text(
                        "Wink",
                        style: GoogleFonts.poppins(
                          color: Color(0xffB70450),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xffB70450),
              ),
            ),
            child: Text(
              "Wink",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
                color: Color(0xffB70450),
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

            if (channel.isEmpty) {
              String randomName1 =
                  randomNames[Random().nextInt(randomNames.length)];
              String randomName2 =
                  randomNames[Random().nextInt(randomNames.length)];

              await eventService.updateWink(
                  context: context,
                  winkId: winkModel.id!,
                  message: winkModel.message,
                  status: WinkStatus.accepted.index);
              final channel = StreamChat.of(context).client.channel(
                    'messaging',
                    extraData: {
                      'members': [SessionHelper.id, widget.user.id],
                      'u1id': SessionHelper.id,
                      'u2id': widget.user.id,
                      '${SessionHelper.id}_name': randomName1,
                      '${widget.user.id}_name': randomName2,
                    },
                    id: StreamApi.generateChannelId(
                      SessionHelper.id,
                      widget.user.id,
                    ),
                  );
              await channel.watch();
            }
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
              color: const Color(0XFFB70450),
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
            bool loading = false;
            final TextEditingController _textEditingController =
                TextEditingController(text: '');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: backgroundColor,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Message ',
                        style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.1),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Enter a message to introduce yourself:',
                        style:
                            GoogleFonts.poppins(fontSize: 12.sp, height: 1.3),
                      ),
                      SizedBox(height: 4.h),
                      TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Hi, I saw your profile and would like to connect...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      CustomButton(
                          loading: loading,
                          buttonText: "Send",
                          onPressed: () async {
                            loading = true;
                            await eventService
                                .wink(
                              context: context,
                              winkToId: widget.user.id,
                              message: _textEditingController.text,
                            )
                                .then((value) {
                              setState(() {
                                status = WinkBoxStatus.winkById;
                                loading = false;
                              });
                              Navigator.of(context).pop();
                            });
                          })
                    ],
                  ),
                ),
              ),
            );

            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: Text('Send Connection Message'),
            //     content: TextField(
            //       controller: _textEditingController,
            //     ),
            //     actions: [
            //       InkWell(
            //         onTap: () async {
            //           await eventService.wink(
            //             context: context,
            //             winkToId: widget.user.id,
            //             message: _textEditingController.text,
            //           );

            //           setState(() {
            //             status = WinkBoxStatus.winkById;
            //           });
            //         },
            //         child: Text("Wink"),
            //       )
            //     ],
            //   ),
            // );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xffB70450),
              ),
            ),
            child: Text(
              "Wink",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w300,
                color: Color(0xffB70450),
              ),
            ),
          ),
        );
    }
  }
}
