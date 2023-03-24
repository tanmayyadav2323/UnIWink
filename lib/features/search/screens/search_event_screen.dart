import 'package:buddy_go/features/search/services/search_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Container(
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
                      onChanged: (String val) async {
                        events =
                            await searchService.searchEvents(context: context,search: val);
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
    );
  }
}
