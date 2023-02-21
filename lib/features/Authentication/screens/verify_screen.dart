import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';
import 'package:buddy_go/features/Authentication/services/auth_services.dart';
import 'package:telephony/telephony.dart';

final OtpFieldController otpFieldController = OtpFieldController();
String otpcode = "";

onBackgroundMessage(SmsMessage message) {
  String sms = message.body.toString();
  log("check msg" + sms.toString());
  otpcode = sms.replaceAll(RegExp(r'[^0-9]'), '');
  otpFieldController.set(otpcode.split(''));
}

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const routename = 'verifyPhoneScreen';

  const VerifyPhoneNumberScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final AuthService _authService = AuthService();
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    initPlatFormState();
    super.initState();
  }

  Future<void> initPlatFormState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        String sms = message.body.toString();
        log("check msg" + sms.toString());
        otpcode = sms.replaceAll(RegExp(r'[^0-9]'), '');
        otpFieldController.set(otpcode.split(''));
        setState(() {});
      },
      onBackgroundMessage: onBackgroundMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              Text(
                "Hey enter your otp + $otpcode",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              OTPTextField(
                style: TextStyle(color: Colors.black),
                controller: otpFieldController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: Colors.white,
                  borderColor: Colors.black,
                ),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  _authService.verifyPhoneNumber(
                    otp: pin,
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
