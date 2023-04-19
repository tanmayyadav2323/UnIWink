import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Function() onPressed;
  final bool loading;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.5.h,
      width: 60.w,
      margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 3.h, bottom: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0XFFB70450),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: widget.loading ? null : widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0XFFB70450),
            ),
            alignment: Alignment.center,
            height: 6.5.h,
            width: double.infinity,
            child: widget.loading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Text(
                    widget.buttonText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
