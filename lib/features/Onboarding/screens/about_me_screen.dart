import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/config/theme_colors.dart';

import '../../../models/user_model.dart';

class AboutMeScreen extends StatefulWidget {
  static const routename = 'about-me-screen';

  final User user;
  final String image;

  const AboutMeScreen({
    Key? key,
    required this.user,
    required this.image,
  }) : super(key: key);

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  List<String> desList = [
    "“I love sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
    "“I am sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
    "“I you sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
    "“I love sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
  ];

  int selectedDes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "About Me",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Write something about yourself like a quote, your areas of interest, what do you seek e.t.c",
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  height: 22.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Transform.scale(
                      scale: 1,
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  height: 24.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color(0XFF25AECC).withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Color(0XFFC4C4C4).withOpacity(0.1),
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
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedDes > 0) {
                            selectedDes--;
                          } else {
                            Fluttertoast.showToast(msg: "No more items");
                          }
                          setState(() {});
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 8.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          desList[selectedDes],
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedDes < desList.length - 1) {
                            selectedDes++;
                          } else {
                            Fluttertoast.showToast(msg: "No more items");
                          }
                          setState(() {});
                        },
                        child: SizedBox(
                          height: double.infinity,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 8.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "Choose your perfect description",
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 6.5.h,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: 8.w, right: 8.w, top: 4.h, bottom: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0XFF642E9B),
                        Color(0XFFFC08D5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0XFFFFF47E6).withOpacity(0.4),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Text(
                    "Set up my Profile",
                    style: GoogleFonts.nunito(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
