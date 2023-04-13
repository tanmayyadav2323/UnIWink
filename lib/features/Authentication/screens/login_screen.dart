import 'dart:math';
import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/authentication/screens/verify_screen.dart';
import 'package:buddy_go/features/authentication/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
    final phoneNumberController = TextEditingController();

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
                  height: 8.h,
                ),
                Text(
                  "Phone Number",
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
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
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      phoneNumberController.text = phone.number;
                    },
                  ),
                ),
                SizedBox(height: 4.h),
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
                      );
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
