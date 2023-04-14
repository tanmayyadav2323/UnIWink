import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/onboarding/screens/choose_ai_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ChooseAvatarScreen extends StatefulWidget {
  static const routename = 'choose-avatar-screen';
  const ChooseAvatarScreen({super.key});

  @override
  State<ChooseAvatarScreen> createState() => _ChooseAvatarScreenState();
}

class _ChooseAvatarScreenState extends State<ChooseAvatarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BgScreen(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(3.h),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "U & I Wink",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Container(
                  padding: EdgeInsets.all(1.75),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: [
                        Color(0XFFA5A5A5),
                        Colors.black.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    height: 33.h,
                    width: 28.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        "assets/images/ai_img.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "Time to Set your AI AVATAR ! ",
                  style: GoogleFonts.poppins(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width) * 0.6,
                  child: Text(
                    "And yes, don’t forget to give a brief description about yourself and your interests....",
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                CustomButton(
                  buttonText: "Choose Avatar",
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ChooseAIAvatarScreen.routename);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
