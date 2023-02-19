
import 'package:buddy_go/config/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ChooseAvatarScreen extends StatefulWidget {
  const ChooseAvatarScreen({super.key});

  @override
  State<ChooseAvatarScreen> createState() => _ChooseAvatarScreenState();
}

class _ChooseAvatarScreenState extends State<ChooseAvatarScreen> {

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
          padding: EdgeInsets.all(3.h),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                "Buddy Go",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                height: 45.h,
                width: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/ai_image1.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "Time to Set your AI AVATAR ! ",
                style: GoogleFonts.nunito(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                "And yes, don’t forget to give a brief description about yourself and your interests....",
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
                  "Choose my Avatar",
                  style: GoogleFonts.nunito(
                    fontSize: 20.sp,
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
    );
  }
}
