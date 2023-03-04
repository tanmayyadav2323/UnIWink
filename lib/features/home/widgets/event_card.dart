import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/images/demo_img2.jpg",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.event.title,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(widget.event.endDateTime.toString()),
                    Text(widget.event.memberIds.toString()),
                    Text(widget.event.rating.toString()),
                    Text("By Whom")
                  ],
                ),
                Spacer(),
                Text("Join")
              ],
            ),
          )
        ],
      ),
    );
  }
}
