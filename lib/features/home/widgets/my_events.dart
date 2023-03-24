import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../authentication/services/auth_services.dart';
import 'event_card.dart';

class MyEvents extends StatefulWidget {
  final String userId;
  const MyEvents({super.key, required this.userId});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final newEvents = await homeServices.getMyEvents(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getMyEvents(context: context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            showSnackBar(context, snapshot.error.toString());
          } else if (snapshot.hasData) {
            events = snapshot.data;
            return ListView(
              children: events.asMap().entries.map((event) {
                return EventCard(
                  event: event.value,
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No data'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
