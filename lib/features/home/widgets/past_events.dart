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
      color: Colors.white,
      onRefresh: () async {
        final newEvents = await homeServices.getAllPastEvents(context: context);
        setState(() {
          events = newEvents;
        });
      },
      child: FutureBuilder(
        future: homeServices.getAllPastEvents(context: context),
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
