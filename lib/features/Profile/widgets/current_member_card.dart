// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../models/user_model.dart' as UserModel;
import '../../../widgets/custom_button.dart';
import '../../Authentication/services/auth_services.dart';

class CurrentMemberCard extends StatefulWidget {
  final UserModel.User user;
  const CurrentMemberCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CurrentMemberCard> createState() => _CurrentMemberCardState();
}

class _CurrentMemberCardState extends State<CurrentMemberCard> {
  late UserModel.User user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "About",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Icon(
                      Icons.mode_edit_outline_outlined,
                      size: 2.5.h,
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  ' " ${user.des} " ',
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w200,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
        buildTile("Privacy Policy", () {}),
        buildTile("Terms of Condition", () {}),
        buildTile("Log Out", () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Are you sure ?",
                  style: GoogleFonts.poppins(fontSize: 16.sp),
                ),
                actions: [
                  CustomButton(
                      buttonText: "Yes",
                      onPressed: () {
                        AuthService().logOut(context);
                        setState(() {});
                      }),
                  CustomButton(
                      buttonText: "No",
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            },
          );
        }, red: true),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }

  buildTile(String title, Function() onPressed, {bool red = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      onTap: onPressed,
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
    );
  }
}
