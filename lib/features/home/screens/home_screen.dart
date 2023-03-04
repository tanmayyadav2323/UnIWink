import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/home/demo/demo_screen.dart';
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

class HomeScreen extends StatefulWidget {
  static const routename = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeServices homeServices = HomeServices();
  List<EventModel> events = [];

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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CreateEventScreen.routename)
                .then((value) {
              setState(() {});
            });
          },
        ),
        body: SafeArea(
          child: BgScreen(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Spacer(),
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
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFFFFFF).withOpacity(0.0),
                            const Color(0x00CC2525),
                          ],
                        ),
                      ),
                      child: Container(
                        height: 5.5.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0x66FFFEFE),
                              const Color(0x1AC4C4C4),
                            ],
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Search for an event",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            suffix: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
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
                    Divider(
                      color: Colors.white,
                    ),
                    allEvents()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget allEvents() {
    return FutureBuilder(
      future: homeServices.getAllEvents(context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          events = snapshot.data;
          return Column(
            children: events.asMap().entries.map((event) {
              return EventCard(event: event.value);
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
