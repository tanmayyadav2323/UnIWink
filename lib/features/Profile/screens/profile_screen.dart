import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "PROFILE",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  height: 15.h,
                  padding: EdgeInsets.all(2),
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/images/ai_bimg/img_2.png",
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(15.h),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xffD2E1E8), Color(0xff2E4766)])),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "Avatar",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    buildContainer(12, "Buddies"),
                    buildContainer(33, "Winks"),
                    buildContainer(2, "Events")
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
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
                          "“I love sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                ),
                buildTile("Favourites", () {}),
                buildTile("Block List", () {}),
                buildTile("Log Out", () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildContainer(int val, String colname) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val.toString(),
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            colname,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  buildTile(String title, Function() onPressed) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap: onPressed,
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
