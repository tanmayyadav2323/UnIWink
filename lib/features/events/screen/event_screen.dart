import 'dart:developer';
import 'dart:ui';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/chat/screens/channel_list_page.dart';
import 'package:buddy_go/features/events/services/event_services.dart';
import 'package:buddy_go/features/events/widgets/custom_modal_sheet.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/features/maps/full_map_screen.dart';
import 'package:buddy_go/widgets/participant_box.dart';
import 'package:buddy_go/models/user_model.dart' as UserModel;
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../widgets/big_load_animations.dart';
import '../../Dashboard/screns/dashboard_screen.dart';
import '../../chat/screens/channel_page.dart';
import 'event_channel_screen.dart';

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
  List bannedUser = [];
  final scrollController = ScrollController();

  List<UserModel.User> participants = [];
  List<String> memberIds = [];
  List eventImages = [];
  final myWidgetKey = GlobalKey();
  bool participant_box = true;
  Channel? channel;
  double? latitude;
  double? longitude;

  bool joinedEvent = false;

  @override
  void initState() {
    getChannel();
    latitude = double.parse(widget.event.latitude);
    longitude = double.parse(widget.event.longitude);
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

  getChannel() async {
    final channels = await StreamChat.of(context)
        .client
        .queryChannels(
          state: true,
          watch: true,
          filter: Filter.in_('id', [widget.event.id!]),
        )
        .first;
    channel = channels.isNotEmpty ? channels[0] : null;
    if (channel != null) {
      bannedUser = (await channel!.queryBannedUsers()).bans;
      log("bannedUser:" + bannedUser.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          controller: scrollController,
          physics: participant_box == false
              ? ClampingScrollPhysics(parent: NeverScrollableScrollPhysics())
              : ScrollPhysics(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pushNamed(
                                FullMapScreen.routename,
                                arguments: [latitude, longitude]);
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: Container(
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xffB70450),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(latitude!, longitude!),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          width: 30.0,
                                          height: 30.0,
                                          point: LatLng(latitude!, longitude!),
                                          builder: (ctx) => Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 4.h),
                      height: 4.h,
                      key: myWidgetKey,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 2.w,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                gradient: participant_box == false
                                    ? LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.4)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                              ),
                              child: InkWell(
                                onTap: () {
                                  participant_box = true;

                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: participant_box
                                        ? Color(0xffB70450)
                                        : backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Participants",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                gradient: participant_box == true
                                    ? LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.4)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                              ),
                              child: InkWell(
                                onTap: () {
                                  participant_box = false;
                                  setState(() {});
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Scrollable.ensureVisible(
                                      curve: Curves.easeIn,
                                      duration: Duration(seconds: 1),
                                      myWidgetKey.currentContext!,
                                    );
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: participant_box == false
                                        ? Color(0xffB70450)
                                        : backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Event Discussion",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
              if (participant_box)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    participantsContainer(),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        "Rate Event",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    eventRateContainer(),
                    SizedBox(
                      height: 4.h,
                    ),
                  ],
                ),
              if (participant_box == false)
                SizedBox(
                  height: 87.5.h,
                  child: channel == null
                      ? BigLoadAnimations()
                      : StreamChannel(
                          key: ValueKey(channel!.cid),
                          channel: channel!,
                          child: ChannelPage(
                            bannedUser: bannedUser,
                            onTap: (String id) async {
                              final reason =
                                  'Reason for banning'; // replace with the reason for banning
                              final response = await channel!.banMember(id, {
                                reason: 'Banned By Admin',
                              });
                            },
                            showBackButton: false,
                            isAdmin: SessionHelper.id ==
                                channel!.extraData["admin"].toString(),
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventRateContainer() {
    return FutureBuilder(
      future:
          eventServices.getRating(context: context, eventId: widget.event.id!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: MediaQuery.of(context).size.width,
            height: 5.h,
            child: RatingBar.builder(
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: 5.h,
              initialRating: snapshot.data,
              itemCount: 5,
              unratedColor: Colors.white.withOpacity(0.3),
              onRatingUpdate: (double value) {
                eventServices.rateEvent(
                    context: context,
                    eventId: widget.event.id!,
                    rateValue: value);
              },
            ),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget participantsContainer() {
    return FutureBuilder(
      future: eventServices.getMembers(
          context: context, members: widget.event.memberIds),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          participants = snapshot.data;
          joinedEvent = memberIds.contains(SessionHelper.id);
          return Column(
            children: [
              if (joinedEvent == false)
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
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
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: participants.map((participant) {
                            return ParticipantBox(
                              dividerOff: true,
                              user: participant,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                await eventServices
                                    .joinEvent(
                                  context: context,
                                  event: widget.event,
                                )
                                    .then((value) {
                                  getChannel();
                                  setState(() {
                                    memberIds.add(SessionHelper.id);
                                  });
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
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    children: participants.map((participant) {
                      return ParticipantBox(
                        user: participant,
                      );
                    }).toList(),
                  ),
                ),
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
