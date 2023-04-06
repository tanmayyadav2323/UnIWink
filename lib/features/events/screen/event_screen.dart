import 'dart:ui';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:buddy_go/features/events/widgets/custom_modal_sheet.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/widgets/participant_box.dart';
import 'package:buddy_go/models/user_model.dart' as UserModel;
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../Dashboard/screns/dashboard_screen.dart';

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
  final HomeServices homeService = HomeServices();
  bool saved = false;

  List<UserModel.User> participants = [];
  List<String> memberIds = [];
  List eventImages = [];

  @override
  void initState() {
    saved = widget.event.savedMembers.contains(SessionHelper.id);
    memberIds = widget.event.memberIds;
    for (int i = 0; i < widget.event.images!.length; i++) {
      eventImages.add(Image.network(
        widget.event.images![i],
        fit: BoxFit.cover,
      ));
    }
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
                child: Stack(
                  children: [
                    ImageCarousel(imageUrls: eventImages),
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
                              InkWell(
                                onTap: () async {
                                  String googleMapsUrl = 'geo:0,0';
                                  if (true) {
                                    await launchURL(context, googleMapsUrl);
                                  } else {
                                    throw 'Could not launch Google Maps.';
                                  }
                                },
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
                              SizedBox(
                                height: 2.h,
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat("dd MMMM, yyyy hh:mm a")
                                            .format(widget.event.startDateTime)
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 2.w,
                                      // ),
                                      // Column(
                                      //   children: [
                                      //     SizedBox(
                                      //       width: 2.w,
                                      //       child: const Divider(
                                      //         color: Colors.white,
                                      //         thickness: 1,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   width: 2.w,
                                      // ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        DateFormat("dd MMMM, yyyy hh:mm a")
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
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           color: const Color(0XFFFF005C),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 2.5.w,
                        //           vertical: 1.h,
                        //         ),
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               DateFormat("MMM")
                        //                   .format(widget.event.endDateTime)
                        //                   .toString(),
                        //               style: GoogleFonts.poppins(
                        //                 fontSize: 10.sp,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: Colors.white,
                        //                 height: 1,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 0.5.h,
                        //             ),
                        //             Text(
                        //               DateFormat("dd")
                        //                   .format(widget.event.endDateTime)
                        //                   .toString(),
                        //               style: GoogleFonts.poppins(
                        //                 fontSize: 10.sp,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: Colors.white,
                        //                 height: 1,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
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
                        widget.event.about,
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      height: 5.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0XFFFF005C),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0XFFFF005C),
                            ),
                            alignment: Alignment.center,
                            height: 6.5.h,
                            width: double.infinity,
                            child: Text(
                              "Discuss",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
                    participantsContainer(),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Rate Event",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 5.h,
                      child: RatingBar.builder(
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 5.h,
                        itemCount: 5,
                        unratedColor: Color(0xffB70450),
                        onRatingUpdate: (double value) {},
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
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
              if (widget.event.authorId != SessionHelper.id)
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
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are you sure to leave event ?"),
                            actions: [
                              CustomButton(
                                buttonText: "Yes",
                                onPressed: () async {
                                  await eventServices
                                      .leaveEvent(
                                    context: context,
                                    eventId: widget.event.id!,
                                  )
                                      .then((value) {
                                    Navigator.of(context).popUntil(
                                      ModalRoute.withName(
                                        DashBoardScreen.routename,
                                      ),
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        DashBoardScreen.routename);
                                  });
                                },
                              ),
                              CustomButton(
                                buttonText: "No",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  },
                ),
              if (widget.event.authorId == SessionHelper.id)
                ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 3.h,
                    ),
                    minLeadingWidth: 1.w,
                    title: Text(
                      "Edit Event",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(CreateEventScreen.routename,
                              arguments: widget.event)
                          .then((value) {});
                    }),
              if (widget.event.authorId != SessionHelper.id)
                ListTile(
                  onTap: () {},
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
                onTap: () async {
                  await homeService.saveEvent(
                    context: context,
                    eventId: widget.event.id!,
                    add: !saved,
                  );
                  setState(() {
                    saved = !saved;
                  });
                  Navigator.of(context).pop();
                },
                leading: Icon(
                  Icons.bookmark,
                  color: Colors.black,
                  size: 3.h,
                ),
                minLeadingWidth: 1.w,
                title: Text(
                  saved ? "Unsave" : "Save",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.event.authorId != SessionHelper.id)
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
              if (widget.event.authorId == SessionHelper.id)
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 3.h,
                  ),
                  minLeadingWidth: 1.w,
                  title: Text(
                    "Delete Event",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are you sure to delete event ?"),
                            content: Text(
                                "All the data will be deleted and you will no longer be able to recover it"),
                            actions: [
                              CustomButton(
                                buttonText: "Yes",
                                onPressed: () async {
                                  await eventServices
                                      .deleteEvent(
                                    context: context,
                                    eventId: widget.event.id!,
                                  )
                                      .then((value) {
                                    Navigator.of(context).popUntil(
                                      ModalRoute.withName(
                                        DashBoardScreen.routename,
                                      ),
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        DashBoardScreen.routename);
                                  });
                                },
                              ),
                              CustomButton(
                                buttonText: "No",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<String> messages = [
    "I just don't like it",
    "It's Spam",
    "Nudity or sexual activity",
    "Hate speech or symbols",
    "False information",
    "Bullying or harrasment",
    "Violence or dangerous organization",
    "Scam or fraud",
    "Intellectual property violation",
    "Sale of illegalor regulated goods",
  ];
  bool _showSecond = true;
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
        return CustomModalSheet(
          eventId: widget.event.id!,
        );
      },
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<dynamic> imageUrls;

  ImageCarousel({required this.imageUrls});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    return FlutterCarousel.builder(
      itemCount: widget.imageUrls.length,
      itemBuilder: (BuildContext context, int index, _) {
        return AspectRatio(
          aspectRatio: 4 / 3,
          child: widget.imageUrls[index],
        );
      },
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 4 / 3,
        autoPlay: true,
        onPageChanged: (int index, CarouselPageChangedReason reason) {},
      ),
    );
  }
}
