// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/features/Profile/widgets/terms_of_condition.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../config/theme_colors.dart';
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
                    GestureDetector(
                      child: Icon(
                        Icons.mode_edit_outline_outlined,
                        size: 2.5.h,
                      ),
                      onTap: () {
                        final _descriptionController = TextEditingController(
                          text: user.des,
                        );
                        bool loading = false;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: backgroundColor,
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Description',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.1),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    'Enter a description about yourself:',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp, height: 1.3),
                                  ),
                                  SizedBox(height: 4.h),
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: null,
                                    maxLength: 500,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Write a few sentences about yourself...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  CustomButton(
                                    loading: loading,
                                    buttonText: "Save",
                                    onPressed: () async {
                                      loading = true;
                                      user = user.copyWith(
                                          des: _descriptionController.text);
                                      HomeServices()
                                          .updateUser(
                                              context: context, user: user)
                                          .then((value) {
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      });

                                      loading = false;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
        buildTile("Privacy Policy", () {
          launchURL(context,
              "https://www.privacypolicies.com/live/92ae9a0b-73c8-4650-836e-93b20e804507");
        }),
        buildTile("Terms and Conditions", () {
          Navigator.of(context).pushNamed(TermsAndConditionScreen.routename);
        }),
        buildTile("Log Out", () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                    fontSize: 16.sp, fontWeight: FontWeight.w600, height: 1.1),
              ),
              backgroundColor: backgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.poppins(fontSize: 12.sp, height: 1.3),
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: [
                      CustomButton(
                        buttonText: "Log Out",
                        onPressed: () async {
                          AuthService().logOut(context);
                        },
                      ),
                      CustomButton(
                        buttonText: "Cancel",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
