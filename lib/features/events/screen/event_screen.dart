import 'dart:developer';
import 'dart:ui';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:buddy_go/features/events/widgets/participant_box.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:buddy_go/models/wink_model.dart';
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
  final EventServices eventServices = EventServices();

  List<User> participants = [];
  List<String> memberIds = [];
  @override
  void initState() {
    memberIds = widget.event.memberIds;
    super.initState();
  }

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
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
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
                        InkWell(
                          onTap: () {
                            modalSheet();
                          },
                          child: Icon(
                            Icons.more_vert,
                            size: 4.h,
                          ),
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
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              const Row(
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
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.watch_later_outlined,
                                      color: Color(0XFFFF005C)),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    DateFormat("hh:mm a")
                                        .format(widget.event.startDateTime)
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 2.w,
                                        child: const Divider(
                                          color: Colors.white,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    DateFormat("hh:mm a")
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
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0XFFFF005C),
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
                        color: const Color(0XFF272A70),
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
                    participantsContainer()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget participantsContainer() {
    return FutureBuilder(
      future: eventServices.getMembers(
          context: context, members: widget.event.memberIds),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          participants = snapshot.data;
          bool joinedEvent = memberIds.contains(SessionHelper.id);
          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              if (joinedEvent == false)
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0XFFFFFEFE).withOpacity(0.4),
                            const Color(0XFFC4C4C4).withOpacity(0.1)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Column(
                          children: participants.map((participant) {
                            return ParticipantBox(
                              user: participant,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              "View and chat with the pariticipants ",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CustomButton(
                              buttonText: "Join",
                              onPressed: () async {
                                await eventServices.joinEvent(
                                  context: context,
                                  event: widget.event,
                                );
                                setState(() {
                                  memberIds.add(SessionHelper.id);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              if (joinedEvent)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: participants.map((participant) {
                      return ParticipantBox(
                        user: participant,
                      );
                    }).toList(),
                  ),
                )
            ],
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  modalSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0XFF444444),
                    borderRadius: BorderRadius.circular(20)),
                height: 0.8.h,
                width: 20.w,
              ),
              SizedBox(
                height: 1.h,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 3.h,
                ),
                minLeadingWidth: 1.w,
                title: Text(
                  "Leave Event",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 3.h,
                ),
                minLeadingWidth: 1.w,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.bookmark,
                  color: Colors.black,
                  size: 3.h,
                ),
                minLeadingWidth: 1.w,
                title: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.report_gmailerrorred,
                  color: Colors.red,
                  size: 3.h,
                ),
                onTap: () {
                  reportmodalSheet();
                },
                minLeadingWidth: 1.w,
                title: Text(
                  "Report Event",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  reportmodalSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0XFF444444),
                      borderRadius: BorderRadius.circular(20)),
                  height: 0.8.h,
                  width: 20.w,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Report",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "Why are you reporting this event?",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                minLeadingWidth: 0,
                leading: null,
                title: Text(
                  "Connect with admin",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
