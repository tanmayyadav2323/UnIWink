// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/features/Onboarding/screens/choose_ai_avatar.dart';
import 'package:buddy_go/features/Onboarding/screens/choose_avatar_screen.dart';
import 'package:buddy_go/features/Profile/widgets/current_member_card.dart';
import 'package:buddy_go/features/Profile/widgets/other_member_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:buddy_go/config/session_helper.dart';
import 'package:buddy_go/config/utils.dart';
import 'package:buddy_go/features/Authentication/services/auth_services.dart';
import 'package:buddy_go/features/Profile/screens/buddy_wink_screen.dart';
import 'package:buddy_go/features/Profile/screens/profile_event_screen.dart';
import 'package:buddy_go/features/Profile/services/profile_services.dart';
import 'package:buddy_go/features/events/screen/event_screen.dart';
import 'package:buddy_go/features/home/services/home_services.dart';
import 'package:buddy_go/models/event_model.dart';
import 'package:buddy_go/models/wink_model.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:buddy_go/widgets/participant_box.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../models/user_model.dart' as UserModel;
import '../../../widgets/big_load_animations.dart';
import '../../chat/screens/channel_page.dart';
import '../widgets/buddy_wink_event_card.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = '/profile-screeen';
  final String id;
  const ProfileScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<EventModel> events = [];
  late UserModel.User user;
  bool loading = false;
  final profileServices = ProfielServices();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    loading = true;
    setState(() {});
    user =
        (await profileServices.getUser(context: context, userId: widget.id))!;

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: loading
            ? BigLoadAnimations()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 3.h,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Profile ",
                            style: GoogleFonts.poppins(
                                fontSize: 20.sp, color: Colors.white),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 3.h,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.id == SessionHelper.id) {
                            Navigator.of(context).pushNamed(
                                ChooseAIAvatarScreen.routename,
                                arguments: true);
                          }
                        },
                        child: Container(
                          height: 15.h,
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            child: Image.network(
                              user.imageUrl,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15.h),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0xffD2E1E8),
                                Color(0xff2E4766)
                              ])),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
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
                      BuddyWinkEventCard(
                        user: user,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      if (user.id == SessionHelper.id)
                        CurrentMemberCard(
                          user: user,
                        ),
                      if (user.id != SessionHelper.id)
                        OtherMemberCard(user: user),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
