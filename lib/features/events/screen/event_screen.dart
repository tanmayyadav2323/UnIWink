import 'dart:ui';

import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:buddy_go/models/event_model.dart';

class EventScreen extends StatefulWidget {
  static const routename = '/event-screen';
  final EventModel event;
  const EventScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.event.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      left: 2.w,
                      child: CircleAvatar(
                        radius: 2.5.h,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 2.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.event.title,
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Icon(
                          Icons.more_vert,
                          size: 4.h,
                        )
                      ],
                    ),
                    Text(
                      "By ${widget.event.organizer}",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0XFFFF005C),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Text(
                                  "Plot no: 2/36 vandhe marg nagar near ",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(Icons.watch_later_outlined,
                                  color: Color(0XFFFF005C)),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                DateFormat("hh:mm")
                                    .format(widget.event.startDateTime)
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              Text(" - "),
                              Text(
                                DateFormat("hh:mm")
                                    .format(widget.event.endDateTime)
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFFFF005C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.5.w,
                                  vertical: 1.h,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat("MMM")
                                          .format(widget.event.endDateTime)
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Text(
                                      DateFormat("dd")
                                          .format(widget.event.endDateTime)
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        color: Color(0XFF272A70),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce rutrum tristique sem, non sagittis sem sollicitudin nec. Vestibulum accumsan eros ac nibh dictum mollis. Phasellus pellentesque ac lacus lobortis lobortis. Nulla et orci diam",
                        style: GoogleFonts.poppins(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "Participants",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0XFFFFFEFE).withOpacity(0.4),
                          Color(0XFFC4C4C4).withOpacity(0.1)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          participantBox(),
                          participantBox(),
                          participantBox(),
                          participantBox(),
                          participantBox(),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            "Join the event to view and chat with the pariticipants ",
                          ),
                          CustomButton(buttonText: "Join", onPressed: () {}),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget participantBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              height: 8.h,
              width: 8.h,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
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
                child: Image.asset(
                  "assets/images/ai_bimg/img_9.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Flexible(
              child: Text(
                "“I love drinks, parties and watching thriller movies. I wish to find an old school guy to have an interactive and fun party eve”",
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          child: Text(
            "Chat",
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0XFFFF005C),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Divider(
          color: Colors.white,
          thickness: 0.2,
        )
      ],
    );
  }
}
