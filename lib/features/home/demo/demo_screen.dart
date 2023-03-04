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
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: widget.child,
        ),
        Positioned(
          left: -51.w,
          top: -16.h,
          child: Container(
            height: 32.h,
            width: 102.w,
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(100.w, 30.h)),
              color: Colors.white,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFF005C).withOpacity(0.6),
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
                  Color(0xFFFF005C).withOpacity(0.55),
                  Color(0xFFFF274E).withOpacity(0),
                ],
                stops: [0.0, 1],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -16.h,
          left: -10.w,
          child: Container(
            height: 32.h,
            width: 120.w,
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(120.w, 32.h)),
              color: Colors.white,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFF005C).withOpacity(0.6),
                  Color(0xFFFF274E).withOpacity(0),
                ],
                stops: [0.0, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
