import 'dart:developer';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/authentication/services/auth_services.dart';
import 'package:buddy_go/features/chat/screens/channel_list_page.dart';

import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/screens/winks_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/features/home/widgets/event_card.dart';
import 'package:buddy_go/features/home/widgets/my_events.dart';
import 'package:buddy_go/features/home/widgets/ongoing_events.dart';
import 'package:buddy_go/features/home/widgets/past_events.dart';

import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/widgets/members_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../providers/user_provider.dart';
import '../../background/bg_screen.dart';
import '../../search/screens/search_event_screen.dart';
import '../widgets/saved_events.dart';

class HomeScreen extends StatefulWidget {
  static const routename = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  List<String> eventsStatus = ["Ongoing", "my event", "prev", "saved"];
  int eventIndex = 0;
  final scrollController = ScrollController();
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: NestedScrollView(
            floatHeaderSlivers: true,
            controller: scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 2.h,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        child: Icon(Icons.logout),
                        onTap: () {
                          AuthService().logOut(context);
                        },
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      InkWell(
                        child: SvgPicture.asset(
                          "assets/icons/logo_icon.svg",
                          height: 2.h,
                        ),
                        onTap: () => Navigator.of(context)
                            .pushNamed(WinkScreen.routename),
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
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(ChannelListPage.routename),
                        child: SvgPicture.asset(
                          "assets/icons/message_icon.svg",
                          height: 2.5.h,
                        ),
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          const Color(0XFF25AECC).withOpacity(0.1),
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
                        gradient: const LinearGradient(
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
                            color: const Color(0XFF000000).withOpacity(0.25),
                            offset: const Offset(0, 4),
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
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SearchEvent.routename);
                        },
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: MembersRow(),
                ),
                SliverAppBar(
                  backgroundColor: backgroundColor,
                  leading: const SizedBox.shrink(),
                  leadingWidth: 0,
                  pinned: true,
                  toolbarHeight: 6.h,
                  flexibleSpace: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    tabs: const [
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
                    onTap: (index) {
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                  ),
                )
              ];
            },
            body: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.linear);
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return OngoingEvents(userId: SessionHelper.id);
                }
                if (index == 1) return MyEvents(userId: SessionHelper.id);
                if (index == 2) return PastEvents(userId: SessionHelper.id);
                return SavedEvents(userId: SessionHelper.id);
              },
              itemCount: 4,
            ),
          ),
        ),
      ),
    );
  }
}
