import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/common_widgets/custom_button.dart';
import 'package:buddy_go/features/Authentication/services/auth_services.dart';

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
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 32.h,
            ),
            TextField(
              controller: _textEditingController,
              style: TextStyle(color: Colors.white),
            ),
            CustomButton(
              buttonText: "Verify Otp",
              onPressed: () {
                _authService.verifyPhoneNumber(
                    otp: _textEditingController.text, context: context);
              },
            )
          ],
        ),
      ),
    );
  }
}
