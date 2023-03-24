import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';
import 'event_card.dart';

class PastEvents extends StatefulWidget {
  final String userId;
  const PastEvents({super.key, required this.userId});

  @override
  State<PastEvents> createState() => _PastEventsState();
}

class _PastEventsState extends State<PastEvents> {
  final HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final newEvents = await homeServices.getAllPastEvents(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getAllPastEvents(context: context),
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
