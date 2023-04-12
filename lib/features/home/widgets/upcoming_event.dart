import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../authentication/services/auth_services.dart';
import 'event_card.dart';

class UpcomingEvent extends StatefulWidget {
  final String userId;
  const UpcomingEvent({super.key, required this.userId});

  @override
  State<UpcomingEvent> createState() => _UpcomingEventState();
}

class _UpcomingEventState extends State<UpcomingEvent> {
  final HomeServices homeServices = HomeServices();
  List<EventModel> events = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        final newEvents = await homeServices.upComingEvents(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.upComingEvents(context: context),
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
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
