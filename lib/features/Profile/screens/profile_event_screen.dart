// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/features/home/widgets/event_card.dart';
import 'package:flutter/material.dart';

import 'package:buddy_go/models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfileEventScreen extends StatefulWidget {
  static const routename = 'profile-event-screen';

  final List<EventModel> eventModels;
  const ProfileEventScreen({
    Key? key,
    required this.eventModels,
  }) : super(key: key);

  @override
  State<ProfileEventScreen> createState() => _ProfileEventScreenState();
}

class _ProfileEventScreenState extends State<ProfileEventScreen> {
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
                  "Events",
                  style:
                      GoogleFonts.poppins(fontSize: 20.sp, color: Colors.white),
                ),
                Column(
                  children: widget.eventModels.map((event) {
                    return EventCard(event: event);
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
