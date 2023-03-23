import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/chat/screens/channel_list_page.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeServices homeServices = HomeServices();
  List<EventModel> events = [];
  List<String> eventsStatus = ["Ongoing", "my event", "prev", "saved"];
  int eventIndex = 0;
  final scrollController = ScrollController();
  int _selectedIndex = 0;
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _selectedIndex);
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    // _tabController.addListener(() {
    //   setState(() {
    //     _selectedIndex = _tabController.index;
    //   });
    // });
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
                      InkWell(
                        onTap: ()=>Navigator.of(context).pushNamed(ChannelListPage.routename),
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
                    padding: EdgeInsets.all(1),
                    margin: EdgeInsets.only(top: 2.h),
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
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
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
                    ],
                  ),
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
                    onTap: (index) {
                      _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 400),
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
                    duration: Duration(milliseconds: 400),
                    curve: Curves.linear);
              },
              itemBuilder: (context, index) {
                if (index == 0) return allOngoingEvents(userProvider.user.id);
                if (index == 1) return myEvents(userProvider.user.id);
                if (index == 2) return prevEvent(userProvider.user.id);
                return saved(userProvider.user.id);
              },
              itemCount: 4,
            ),
          ),
        ),
      ),
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
          return ListView(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) async {},
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
          return ListView(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) async {},
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
          return ListView(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) async {},
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
          return ListView(
            children: events.asMap().entries.map((event) {
              return EventCard(
                onSaved: (val) async {},
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
