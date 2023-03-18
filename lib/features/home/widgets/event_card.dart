import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:buddy_go/features/events/screen/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/models/event_model.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  final bool bookMarked;
  final Function(bool) onSaved;
  const EventCard({
    Key? key,
    required this.event,
    required this.bookMarked,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool bookMarked = false;
  @override
  void initState() {
    bookMarked = widget.bookMarked;
    setState(() {});
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
        margin: EdgeInsets.symmetric(vertical: 2.h),
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.event.image),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 1.5.h,
              right: 2.w,
              child: InkWell(
                onTap: () {
                  bookMarked = !bookMarked;
                  widget.onSaved(bookMarked);
                  setState(() {});
                },
                child: CircleAvatar(
                  radius: 2.h,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bookmark_outlined,
                    color: bookMarked ? Color(0XFF6C6C82) : Colors.green,
                    size: 3.h,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 1.h,
              child: GlassmorphicContainer(
                height: 15.h,
                border: 1,
                borderRadius: 15,
                borderGradient: LinearGradient(colors: [
                  Color(0XFFFFFFFF),
                  Color(0XFFCC2525).withOpacity(0.0)
                ]),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                linearGradient: LinearGradient(
                  colors: [
                    Color(0XFFFFFEFE).withOpacity(0.4),
                    Color(0XFFC4C4C4).withOpacity(0.1),
                  ],
                ),
                blur: 24,
                
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Column(
                    children: [
                      Row(
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.location_on)
                                ],
                              ),
                              Text(
                                "by ${widget.event.organizer}",
                                style: GoogleFonts.poppins(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                    color: Colors.black,
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
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        height: 5.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: AvatarStack(
                                borderColor: Colors.white,
                                height: 4.h,
                                avatars: [
                                  for (var n = 0;
                                      n <
                                          widget.event.memberImageUrls.length +
                                              30;
                                      n++)
                                    NetworkImage(
                                      widget.event.memberImageUrls[0],
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
                                      rating: 4,
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
