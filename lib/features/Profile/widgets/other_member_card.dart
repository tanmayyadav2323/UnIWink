// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';

import '../../../models/user_model.dart' as UserModel;
import '../../chat/screens/channel_page.dart';

class OtherMemberCard extends StatefulWidget {
  final UserModel.User user;
  const OtherMemberCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<OtherMemberCard> createState() => _OtherMemberCardState();
}

class _OtherMemberCardState extends State<OtherMemberCard> {
  final _nameController = TextEditingController();
  late UserModel.User user;
  bool _isEditing = false;
  final _focusNode = FocusNode();
  @override
  void initState() {
    user = widget.user;
    _queryChannels();
  }

  Channel? channel;
  Future<void> _queryChannels() async {
    final channels = await StreamChat.of(context)
        .client
        .queryChannels(
          state: true,
          watch: true,
          filter: Filter.and([
            Filter.in_('members', [user.id]),
            Filter.notExists('channel_type'),
          ]),
        )
        .first;
    if (channels.isNotEmpty) {
      channel = channels[0];
      _nameController.text = channel!.extraData["${user.id}_name"].toString();
      log("hey hello ${channel!.cid}");
      setState(() {});
    }
  }

  bool edit = true;

  @override
  Widget build(BuildContext context) {
    return channel == null
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        readOnly: !_isEditing,
                        onTap: () {
                          edit = false;
                        },
                        focusNode: _focusNode,
                        controller: _nameController,
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // focusedBorder: UnderlineInputBorder(),
                          suffixIcon: _isEditing
                              ? GestureDetector(
                                  child: Icon(Icons.save),
                                  onTap: () async {
                                    // Save text and exit edit mode
                                    await channel!.update({
                                      "${user.id}_name": _nameController.text
                                    });
                                    _isEditing = false;

                                    setState(() {});
                                  },
                                )
                              : GestureDetector(
                                  child: Icon(Icons.edit),
                                  onTap: () {
                                    // Enter edit mode
                                    _focusNode.requestFocus();
                                    _isEditing = true;
                                    setState(() {});
                                  },
                                ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StreamChannel(
                              key: ValueKey(channel!.cid),
                              channel: channel!,
                              child: ChannelPage(
                                onTap: () {},
                                name: channel!.extraData["${user.id}_name"]
                                    .toString(),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: Color(0xffB70450),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Chat",
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "About",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  ' " ${user.des} " ',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ],
            ));
  }
}
