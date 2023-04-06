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
      color: Colors.white,
      onRefresh: () async {
        final newEvents = await homeServices.getSavedEvent(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getSavedEvent(context: context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            showSnackBar(context, snapshot.error.toString());
          } else {
            if (snapshot.hasData) events = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    height: snapshot.hasData == false
                        ? MediaQuery.of(context).size.height * 0.2
                        : 0,
                    width: double.infinity,
                    duration: Duration(
                      milliseconds: 400,
                    ),
                    // child: Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                  ),
                  if (snapshot.hasData)
                    AnimatedContainer(
                      duration: Duration(
                        milliseconds: 400,
                      ),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: events.asMap().entries.map((event) {
                          return EventCard(
                            event: event.value,
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
