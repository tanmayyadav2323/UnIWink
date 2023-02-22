import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      height: 7.h,
      width: 70.w,
      margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 3.h, bottom: 3.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: widget.loading ? null : widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            height: 6.5.h,
            width: double.infinity,
            child: widget.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    widget.buttonText,
                    style: GoogleFonts.nunito(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
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
