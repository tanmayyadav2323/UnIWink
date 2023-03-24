import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../authentication/services/auth_services.dart';
import 'event_card.dart';

class OngoingEvents extends StatefulWidget {
  final String userId;
  const OngoingEvents({super.key, required this.userId});

  @override
  State<OngoingEvents> createState() => _OngoingEventsState();
}

class _OngoingEventsState extends State<OngoingEvents> {
  final HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final newEvents = await homeServices.getOngoingEvents(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getOngoingEvents(context: context),
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
