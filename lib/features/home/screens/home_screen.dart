import 'package:buddy_go/config/utils.dart';

import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/features/home/widgets/event_card.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../providers/user_provider.dart';
import '../../background/bg_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routename = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  List<String> eventsStatus = ["Ongoing", "my event", "prev", "saved"];
  int eventIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateEventScreen.routename)
                  .then((value) {
                setState(() {});
              });
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          SvgPicture.asset(
                            "assets/icons/logo_icon.svg",
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          SvgPicture.asset(
                            "assets/icons/profile_icon.svg",
                            height: 2.5.h,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          SvgPicture.asset(
                            "assets/icons/message_icon.svg",
                            height: 2.5.h,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0XFF25AECC).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          height: 5.5.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0XFF6C6D83),
                                Color(0XFF202143),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              transform: GradientRotation(13),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0XFF000000).withOpacity(0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Search for an event",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        height: 8.h,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(userProvider.user.imageUrl),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      PreferredSize(
                          child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: Colors.white,
                            tabs: [
                              Tab(
                                child: Text('Ongoing Events'),
                              ),
                              Tab(
                                child: Text('My Events'),
                              ),
                              Tab(
                                child: Text('Past Events'),
                              ),
                              Tab(
                                child: Text('Saved Events'),
                              ),
                            ],
                          ),
                          preferredSize: Size.fromHeight(30.0)),
                      SizedBox(
                        height: 1.h,
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            allOngoingEvents(userProvider.user.id),
                            myEvents(userProvider.user.id),
                            prevEvent(userProvider.user.id),
                            saved(userProvider.user.id)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget myEvents(String userId) {
    return FutureBuilder(
      future: homeServices.getMyEvents(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          events = snapshot.data;
          return Column(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) {},
                event: event.value,
                bookMarked: event.value.savedMembers.contains(userId),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget prevEvent(String userId) {
    return FutureBuilder(
      future: homeServices.getAllPastEvents(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          events = snapshot.data;
          return Column(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) {},
                event: event.value,
                bookMarked: event.value.savedMembers.contains(userId),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget saved(String userId) {
    return FutureBuilder(
      future: homeServices.getSavedEvent(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          events = snapshot.data;
          return Column(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) {},
                event: event.value,
                bookMarked: event.value.savedMembers.contains(userId),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget allOngoingEvents(String userId) {
    return FutureBuilder(
      future: homeServices.getOngoingEvents(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          events = snapshot.data;
          return Column(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) async {
                  await homeServices.saveEvent(
                    context: context,
                    eventId: event.value.id!,
                    userId: userId,
                    add: val,
                  );
                },
                event: event.value,
                bookMarked: event.value.savedMembers.contains(userId),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No data'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
