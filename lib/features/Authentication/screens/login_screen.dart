import 'dart:math';
import 'package:buddy_go/features/Profile/widgets/terms_of_condition.dart';
import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/authentication/screens/verify_screen.dart';
import 'package:buddy_go/features/authentication/services/auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final phoneNumberController = TextEditingController();

class LoginScreen extends StatefulWidget {
  static const routename = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        print("Signature:${signature}");
      });
    });
  }

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BgScreen(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "UnIw",
                      style: TextStyle(fontSize: 32.sp, letterSpacing: 6),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    SvgPicture.asset("assets/icons/logo.svg", height: 6.h),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "nk",
                      style: TextStyle(fontSize: 32.sp, letterSpacing: 6),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntlPhoneField(
                    onCountryChanged: (value) => null,
                    countries: ['IN'],
                    autofocus: true,
                    dropdownIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    disableLengthCheck: true,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      if (phone.number.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                      phoneNumberController.text = phone.number;
                    },
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontFamily: 'Poppins',
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'By Signing in you are accepting '),
                      TextSpan(
                        text: ' Privacy Policy ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchURL(context,
                                "https://www.privacypolicies.com/live/92ae9a0b-73c8-4650-836e-93b20e804507");
                          },
                      ),
                      TextSpan(text: 'and '),
                      TextSpan(
                        text: ' Terms and Conditions ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context)
                                .pushNamed(TermsAndConditionScreen.routename);
                          },
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  buttonText: "Login",
                  loading: false,
                  onPressed: () async {
                    if (phoneNumberController.text.length != 10) {
                      showSnackBar(
                        context,
                        "Phone number must be of 10 digits",
                      );
                    } else {
                      String userId = await _authService.authenticateUserPhone(
                        phoneNumber: phoneNumberController.text,
                        context: context,
                      );

                      Navigator.of(context).pushNamed(
                        VerifyPhoneNumberScreen.routename,
                        arguments: [userId, phoneNumberController.text],
                      ).then((value) {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
