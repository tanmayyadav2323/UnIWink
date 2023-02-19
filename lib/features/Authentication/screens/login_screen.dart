import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  static const routename = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0XFF150829),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
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
                        height: 2.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Taking you to match your best buddy. Get ready to be on an anonymously fun ride",
                          style: GoogleFonts.nunito(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 6.5.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0XFF25AECC).withOpacity(0.4)),
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            border: InputBorder.none,
                            counterText: "",
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          cursorColor: Colors.white,
                          maxLength: 10,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 6.5.h,
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: 8.w, right: 8.w, top: 4.h, bottom: 3.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color(0XFF642E9B),
                              Color(0XFFFC08D5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0XFFFFF47E6).withOpacity(0.4),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.nunito(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "or",
                              style: GoogleFonts.nunito(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0XFFCCCCCC),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 6.5.h,
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Spacer(),
                            Image.asset(
                              "assets/images/google_logo.png",
                              height: 3.h,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Sign In With Google",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Image.asset(
                  "assets/images/login_page_1.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
