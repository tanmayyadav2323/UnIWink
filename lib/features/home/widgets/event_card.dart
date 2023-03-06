import 'package:avatar_stack/avatar_stack.dart';
import 'package:buddy_go/features/events/screen/event_screen.dart';
import 'package:flutter/material.dart';
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
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
          ),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              const Color(0XFFC4C4C4).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: const GradientRotation(13),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF000000).withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            )
          ],
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
              top: 1.h,
              right: 1.w,
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
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.75,
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.event.title,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                            ),
                            Text(
                              "by ${widget.event.organizer}",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                            )
                          ],
                        ),
                        Spacer(),
                        Text(
                          DateFormat('yyyy-MM-dd – kk:mm')
                              .format(widget.event.endDateTime)
                              .toString(),
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AvatarStack(
                            height: 40,
                            width: 150,
                            avatars: [
                              for (var n = 0;
                                  n < widget.event.memberImageUrls.length;
                                  n++)
                                NetworkImage(widget.event.memberImageUrls[n]),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.black,
                            thickness: 3,
                            width: 1,
                          ),
                          Text(
                            "Rating: ${widget.event.rating}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
