import 'dart:developer';
import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/events/screen/event_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/models/event_model.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool bookMarked = false;
  final HomeServices homeService = HomeServices();
  bool displayStartDateTime = false;
  @override
  void initState() {
    displayStartDateTime =
        widget.event.startDateTime.isAfter(DateTime.now()) ? true : false;
    bookMarked = widget.event.savedMembers.contains(SessionHelper.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EventScreen.routename,
            arguments: {"event": widget.event});
      },
      child: Container(
        margin: EdgeInsets.only(top: 3.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Color(0XFFA5A5A5),
                        Colors.black.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.event.image),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2.h,
              right: 2.w,
              child: InkWell(
                onTap: () async {
                  bookMarked = !bookMarked;
                  await homeService.saveEvent(
                    context: context,
                    eventId: widget.event.id!,
                    add: bookMarked,
                  );
                  setState(() {});
                },
                child: CircleAvatar(
                  radius: 2.h,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bookmark_outlined,
                    color: bookMarked ? Color(0XFFB70450) : Color(0xff6C6C82),
                    size: 3.h,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 3.h,
              child: Container(
                height: 15.h,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.event.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Icon(Icons.location_on)
                                  ],
                                ),
                                Text(
                                  "by ${widget.event.organizer}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            Container(
                              height: 10.w,
                              width: 10.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat("MMM")
                                        .format(displayStartDateTime
                                            ? widget.event.startDateTime
                                            : widget.event.endDateTime)
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Text(
                                    DateFormat("dd")
                                        .format(displayStartDateTime
                                            ? widget.event.startDateTime
                                            : widget.event.endDateTime)
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: AvatarStack(
                                borderColor: Color(0xff43333E),
                                height: 4.h,
                                avatars: [
                                  for (var n = 0;
                                      n < widget.event.memberImageUrls.length;
                                      n++)
                                    NetworkImage(
                                      widget.event.memberImageUrls[n],
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: VerticalDivider(
                                color: Colors.white,
                                thickness: 1,
                                width: 1,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: RatingBarIndicator(
                                      rating: widget.event.rating,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemSize: 2.5.h,
                                      itemCount: 5,
                                      unratedColor: Colors.amber.withAlpha(50),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
