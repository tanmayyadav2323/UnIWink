import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/config/theme_colors.dart';

import '../../../models/user_model.dart';
import 'expandable_carsouel.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  SizedBox(
                    height: 2.h,
                  ),
                  CarouselView(),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: Colors.white.withOpacity(0.4)),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "or write a custom description of your self",
                        hintStyle: GoogleFonts.nunito(
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 200,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomButton(
                    buttonText: "Set up my Profile",
                    onPressed: () {

                    },
                  ),
                  SizedBox(
                    height: 4.h,
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
