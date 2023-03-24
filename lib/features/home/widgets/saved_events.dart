import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../authentication/services/auth_services.dart';
import 'event_card.dart';

class SavedEvents extends StatefulWidget {
  final String userId;
  const SavedEvents({super.key, required this.userId});

  @override
  State<SavedEvents> createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {
  final HomeServices homeServices = HomeServices();
  List<EventModel> events = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final newEvents = await homeServices.getSavedEvent(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getSavedEvent(context: context),
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
