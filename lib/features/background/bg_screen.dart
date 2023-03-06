import 'dart:ui';

import 'package:buddy_go/config/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BgScreen extends StatefulWidget {
  const BgScreen({super.key, required this.child});
  final Widget child;
  @override
  State<BgScreen> createState() => _BgScreenState();
}

class _BgScreenState extends State<BgScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Stack(
          children: [
            Positioned(
              left: -44.w,
              top: -23.h,
              child: Container(
                height: 40.h,
                width: 120.w,
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(100.w, 30.h)),
                  color: Colors.white,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.5),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.20,
              left: size.width * 0.2,
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.5),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -22.h,
              left: -15.w,
              child: Container(
                height: 40.h,
                width: 140.w,
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(140.w, 40.h)),
                  color: Colors.white,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.5),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height,
              width: size.width,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
