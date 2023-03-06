import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Image.network(
              widget.event.image,
              fit: BoxFit.fill,
            ),
          ),
          Text(widget.event.title),
          Text(widget.event.organizer),
          Text(widget.event.about),
        ],
      ),
    );
  }
}
