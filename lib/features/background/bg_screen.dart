import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/config/theme_colors.dart';

class BgScreen extends StatefulWidget {
  final bool centerGradient;
  final bool singleCenterGradient;
  const BgScreen({
    Key? key,
    this.centerGradient = true,
    this.singleCenterGradient = false,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  State<BgScreen> createState() => _BgScreenState();
}

class _BgScreenState extends State<BgScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BackdropFilter(
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
                borderRadius: BorderRadius.all(Radius.elliptical(100.w, 30.h)),
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
          if (widget.singleCenterGradient)
            Positioned(
              top: size.height * 0.16,
              left: size.width * 0.1,
              child: Container(
                height: 35.h,
                width: 35.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.4),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
          if (widget.centerGradient)
            Positioned(
              top: size.height * 0.3,
              right: size.width * 0.2,
              child: Container(
                height: 45.h,
                width: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.4),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
          if (widget.centerGradient)
            Positioned(
              top: size.height * 0.10,
              left: size.width * 0.2,
              child: Container(
                height: 45.h,
                width: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF005C).withOpacity(0.4),
                      Color(0xFFFF274E).withOpacity(0),
                    ],
                    stops: [0.0, 1],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: -8.h,
            left: 6.w,
            child: Container(
                height: 20.h,
                width: 90.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ellipse_gradient.png'),
                    fit: BoxFit.fill,
                  ),
                )),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
