import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/features/onboarding/services/onboarding_services.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  int selectedDes = 0;

  TextEditingController _desController = TextEditingController();

  @override
  void dispose() {
    _desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BgScreen(
          centerGradient: false,
          singleCenterGradient: true,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      "About Me",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Write something about yourself like a quote, your areas of interest, what do you seek e.t.c',
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(1.75),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                        height: 18.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Transform.scale(
                            scale: 1,
                            child: Image.asset(
                              widget.user.gender == "male"
                                  ? "assets/images/ai_bimg/${widget.image}.png"
                                  : "assets/images/ai_gimg/${widget.image}.png",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "Choose what best describes you",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0XFF25AECC).withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CarouselView(
                        onPressed: (text) {
                          _desController.text = text;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Colors.white.withOpacity(0.4)),
                        ),
                      ),
                      child: TextFormField(
                        controller: _desController,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "or write a custom description",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 9.5.sp,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                          border: InputBorder.none,
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 200,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomButton(
                      buttonText: "Set Profile",
                      onPressed: () async {
                        if (_desController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter some text");
                        } else {
                          final user =
                              widget.user.copyWith(des: _desController.text);
                          await OnBoardingServices().setUpAccount(
                            context: context,
                            user: user,
                            imagePath: widget.user.gender == "male"
                                ? "assets/images/ai_bimg/${widget.image}.png"
                                : "assets/images/ai_gimg/${widget.image}.png",
                          );
                        }
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
      ),
    );
  }
}
