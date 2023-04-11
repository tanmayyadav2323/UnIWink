// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';

import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/Profile/screens/buddy_wink_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../models/user_model.dart' as UserModel;
import '../screens/profile_event_screen.dart';
import '../services/profile_services.dart';

class BuddyWinkEventCard extends StatefulWidget {
  final UserModel.User user;

  const BuddyWinkEventCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<BuddyWinkEventCard> createState() => _BuddyWinkEventCardState();
}

class _BuddyWinkEventCardState extends State<BuddyWinkEventCard> {
  final HomeServices homeServices = HomeServices();
  final profileServices = ProfielServices();

  late UserModel.User user;
  List<EventModel> events = [];

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  getUserEvents() async {
    events = await profileServices.getUserEvents(
        context: context, userId: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homeServices.winkMembers(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          final participants = snapshot.data as List<UserModel.User>;
          List<UserModel.User> buddyUsers = [];
          List<UserModel.User> winks = [];

          for (int i = 0; i < participants.length; i++) {
            for (int j = 0; j < participants[i].winks.length; j++) {
              if (participants[i].winks[j]['winkedToId'] == user.id ||
                  participants[i].winks[j]['winkedById'] == user.id) {
                if (participants[i].winks[j]["status"] == 0) {
                  buddyUsers.add(participants[i]);
                } else {
                  winks.add(participants[i]);
                }
              }
            }
          }

          return Row(
            children: [
              buildContainer(buddyUsers.length, "Buddies", () {
                Navigator.of(context).pushNamed(BuddyWinkScreen.routename,
                    arguments: buddyUsers);
              }),
              buildContainer(winks.length, "Winks", () {
                Navigator.of(context)
                    .pushNamed(BuddyWinkScreen.routename, arguments: winks);
              }),
              buildContainer(events.length, "Events", () {
                Navigator.of(context)
                    .pushNamed(ProfileEventScreen.routename, arguments: events);
              })
            ],
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  buildContainer(int val, String colname, Function() onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              val.toString(),
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              colname,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
