// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:buddy_go/widgets/participant_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class BuddyWinkScreen extends StatefulWidget {
  static const routename = 'buddyWink-screen';
  final List<User> users;
  const BuddyWinkScreen({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  State<BuddyWinkScreen> createState() => _BuddyWinkScreenState();
}

class _BuddyWinkScreenState extends State<BuddyWinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Members",
                  style:
                      GoogleFonts.poppins(fontSize: 20.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Column(
                  children: widget.users.map((participant) {
                    return ParticipantBox(
                      user: participant,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
