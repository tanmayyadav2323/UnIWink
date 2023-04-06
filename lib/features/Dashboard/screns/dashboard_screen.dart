import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/home/screens/create_event_screen.dart';
import 'package:buddy_go/features/home/screens/home_screen.dart';
import 'package:buddy_go/features/home/screens/winks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sizer/sizer.dart';

class DashBoardScreen extends StatefulWidget {
  static const routename = '/dashboard-screen';
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool home = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: home ? HomeScreen() : WinkScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white, width: 0.75),
          ),
        ),
        width: double.infinity,
        height: 6.h,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: home
                  ? Container(
                      child: GestureDetector(
                        child: SvgPicture.asset("assets/icons/solid_home.svg",
                            height: 3.h),
                        onTap: () {},
                      ),
                    )
                  : GestureDetector(
                      child: SvgPicture.asset("assets/icons/outlined_home.svg",
                          height: 3.h),
                      onTap: () {
                        home = true;
                        setState(() {});
                      },
                    ),
            ),
            Expanded(child: Container()),
            Expanded(
              flex: 3,
              child: home
                  ? GestureDetector(
                      child: SvgPicture.asset("assets/icons/outlined_wink.svg",
                          height: 2.5.h),
                      onTap: () {
                        home = false;
                        setState(() {});
                      },
                    )
                  : GestureDetector(
                      child: SvgPicture.asset("assets/icons/solid_wink.svg",
                          height: 2.5.h),
                      onTap: () {},
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(CreateEventScreen.routename, arguments: null);
        },
        child: Container(
          color: backgroundColor,
          child: SvgPicture.asset("assets/icons/outlined_add.svg", height: 5.h),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
