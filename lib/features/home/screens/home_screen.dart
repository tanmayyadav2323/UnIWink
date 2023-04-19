// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:buddy_go/features/Profile/screens/profile_screen.dart';
import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/features/home/widgets/joined_events.dart';
import 'package:buddy_go/features/home/widgets/upcoming_event.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/features/home/widgets/my_events.dart';
import 'package:buddy_go/features/home/widgets/ongoing_events.dart';
import 'package:buddy_go/features/home/widgets/past_events.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/widgets/members_row.dart';
import 'package:timeago/timeago.dart';

import '../../chat/screens/channel_list_page.dart';
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
  int prevIndex = 0;
  final scrollController = ScrollController();
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: 0,
    );
    _pageController = PageController(
      initialPage: 0,
    );
    _tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context)
      //         .pushNamed(CreateEventScreen.routename)
      //         .then((value) {
      //       setState(() {});
      //     });
      //   },
      // ),
      body: SafeArea(
        child: BgScreen(
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
                  // SliverToBoxAdapter(
                  //   child: Row(
                  //     children: [
                  //       const Spacer(),
                  //       InkWell(
                  //         child: Icon(Icons.logout),
                  //         onTap: () {
                  //           AuthService().logOut(context);
                  //         },
                  //       ),
                  //       SizedBox(
                  //         width: 6.w,
                  //       ),
                  //       InkWell(
                  //         child: SvgPicture.asset(
                  //           "assets/icons/logo_icon.svg",
                  //           height: 2.h,
                  //         ),
                  //         onTap: () => Navigator.of(context)
                  //             .pushNamed(WinkScreen.routename),
                  //       ),
                  //       SizedBox(
                  //         width: 6.w,
                  //       ),
                  //       SvgPicture.asset(
                  //         "assets/icons/profile_icon.svg",
                  //         height: 2.5.h,
                  //       ),
                  //       SizedBox(
                  //         width: 6.w,
                  //       ),
                  //       InkWell(
                  //         onTap: () => Navigator.of(context)
                  //             .pushNamed(ChannelListPage.routename),
                  //         child: SvgPicture.asset(
                  //           "assets/icons/message_icon.svg",
                  //           height: 2.5.h,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 5.5.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SearchEvent.routename);
                              },
                              child: Container(
                                padding: EdgeInsets.all(0.75),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.4)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Container(
                                    height: 5.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(1.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: backgroundColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Search for an Event",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/outlined_search.svg",
                                          height: 2.h,
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ProfileScreen.routename,
                                      arguments: SessionHelper.id,
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/outlined_profile.svg",
                                    height: 2.75.h,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(ChannelListPage.routename);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/outlined_msg.svg",
                                    height: 3.h,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: MembersRow(),
                  ),
                  SliverAppBar(
                    shadowColor: backgroundColor,
                    foregroundColor: backgroundColor,
                    surfaceTintColor: backgroundColor,
                    backgroundColor: Colors.transparent,
                    leading: null,
                    leadingWidth: 0,
                    pinned: true,
                    toolbarHeight: 4.h,
                    floating: true,
                    flexibleSpace: TabBar(
                      indicatorPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(color: Colors.transparent),
                      unselectedLabelColor: Colors.white,
                      indicatorColor: Colors.transparent,
                      padding: null,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      controller: _tabController,
                      tabs: [
                        EventTab(
                            tabController: _tabController,
                            text: "Ongoing",
                            index: 0),
                        EventTab(
                            tabController: _tabController,
                            text: "Upcoming",
                            index: 1),
                        EventTab(
                            tabController: _tabController,
                            text: "Created",
                            index: 2),
                        EventTab(
                            tabController: _tabController,
                            text: "Joined",
                            index: 3),
                        EventTab(
                            tabController: _tabController,
                            text: "Past",
                            index: 4),
                        EventTab(
                            tabController: _tabController,
                            text: "Saved",
                            index: 5),
                      ],
                      onTap: (index) {
                        print(index.toString());

                        _pageController.jumpToPage(
                          index,
                          // duration: Duration(milliseconds: 400),
                          // curve: Curves.linear,
                        );
                        prevIndex = index;
                      },
                    ),
                  ),
                ];
              },
              body: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(
                    index,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.linear,
                  );
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: OngoingEvents(userId: SessionHelper.id),
                    );
                  }
                  if (index == 1) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: UpcomingEvent(userId: SessionHelper.id),
                    );
                  }
                  if (index == 2) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: MyEvents(userId: SessionHelper.id),
                    );
                  }
                  if (index == 3) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: JoinedEvents(userId: SessionHelper.id),
                    );
                  }
                  if (index == 4) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: PastEvents(userId: SessionHelper.id),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.only(top: 1.h),
                    child: SavedEvents(userId: SessionHelper.id),
                  );
                },
                itemCount: 6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventTab extends StatefulWidget {
  final TabController tabController;
  final String text;
  final int index;
  const EventTab({
    Key? key,
    required this.tabController,
    required this.text,
    required this.index,
  }) : super(key: key);

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  @override
  void initState() {
    widget.tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      height: 11.h,
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        gradient: widget.tabController.index != widget.index
            ? LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: widget.tabController.index == widget.index
                ? Color(0xffB70450).withOpacity(0.8)
                : backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          width: 24.w,
          height: 10.h,
          child: Text(widget.text),
        ),
      ),
    );
  }
}
