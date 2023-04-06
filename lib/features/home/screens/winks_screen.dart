import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/widgets/participant_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../models/user_model.dart';
import '../services/home_services.dart';

class WinkScreen extends StatefulWidget {
  static const routename = '/winks-screen';

  const WinkScreen({super.key});

  @override
  State<WinkScreen> createState() => _WinkScreenState();
}

class _WinkScreenState extends State<WinkScreen> {
  final homeServices = HomeServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Winks",
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              winkMemberContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<User>> winkMemberContainer(BuildContext context) {
    return FutureBuilder(
      future: homeServices.winkMembers(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          final participants = snapshot.data as List<User>;

          return Column(
            children: participants.map((participant) {
              return ParticipantBox(
                user: participant,
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
