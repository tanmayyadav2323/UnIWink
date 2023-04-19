import 'package:buddy_go/features/search/services/search_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sizer/sizer.dart';

import '../../../config/theme_colors.dart';
import '../../Home/widgets/event_card.dart';

class SearchEvent extends StatefulWidget {
  static const routename = '/search-event';

  const SearchEvent({super.key});

  @override
  State<SearchEvent> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  bool loading = false;
  List<EventModel> events = [];
  final searchService = SearchServices();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(0.75),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.4)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Container(
                      height: 5.5.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundColor,
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Search for an Event",
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.75.h),
                            child: SvgPicture.asset(
                              "assets/icons/outlined_search.svg",
                            ),
                          ),
                        ),
                        onChanged: (String val) async {
                          events = await searchService.searchEvents(
                              context: context, search: val);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: events.asMap().entries.map((event) {
                      return EventCard(
                        event: event.value,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
