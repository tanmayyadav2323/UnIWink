import 'dart:ui';

import 'package:buddy_go/common_widgets/custom_button.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/Authentication/services/auth_services.dart';
import 'package:buddy_go/features/Onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/models/user_model.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/user_provider.dart';

class ChooseAIAvatarScreen extends StatefulWidget {
  static const routename = '/choose-ai-avatar';

  const ChooseAIAvatarScreen({super.key});

  @override
  State<ChooseAIAvatarScreen> createState() => _ChooseAIAvatarScreenState();
}

class _ChooseAIAvatarScreenState extends State<ChooseAIAvatarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GlobalKey _appBarKey;
  late double _appBarHight;

  //images male
  List<String> imageMale = [
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
  ];

  List<String> imageFemale = [
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
    "assets/images/ai_avatar_img1.png",
    "assets/images/ai_avatar_img2.png",
    "assets/images/ai_avatar_img3.png",
  ];

  @override
  void initState() {
    _appBarKey = GlobalKey();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  int indexMale = -1;
  int indexFemale = -1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: backgroundColor,
                    leading: const SizedBox.shrink(),
                    leadingWidth: 0,
                    title: Column(
                      children: [
                        Text(
                          "AI avatar",
                          style: TextStyle(
                            fontSize: 25.sp,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "Choose the AI Avatar that best aligns with you and your traits",
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: true,
                    floating: true,
                    pinned: true,
                    toolbarHeight: 20.h,
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 1,
                      isScrollable: true,
                      tabs: const [
                        Tab(
                          child: Text(
                            "Male",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Female",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      controller: _tabController,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                      itemCount: imageMale.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            border: indexMale == index
                                ? Border.all(color: Colors.blue)
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.blue.withOpacity(0.4),
                              hoverColor: Colors.blue.withOpacity(0.4),
                              onTap: () {
                                indexFemale = -1;
                                if (indexMale == index) {
                                  indexMale = -1;
                                } else {
                                  indexMale = index;
                                }
                                setState(() {});
                              },
                              child: Image.asset(
                                imageMale[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: imageFemale.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            border: indexFemale == index
                                ? Border.all(color: Colors.blue)
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                indexMale = -1;
                                if (indexFemale == index) {
                                  indexFemale = -1;
                                } else {
                                  indexFemale = index;
                                }
                                setState(() {});
                              },
                              child: Image.asset(
                                imageFemale[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: BackdropFilter(
                filter: ImageFilter.blur(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withOpacity(0.5),
                        backgroundColor,
                      ],
                      stops: [0, 0.6],
                    ),
                  ),
                  height: 18.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        buttonText: "Set My Avatar",
                        onPressed: saveImage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveImage() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (indexMale >= 0) {
      final user = userProvider.user.copyWith(gender: "male");
      Navigator.of(context).pushNamed(AboutMeScreen.routename,
          arguments: {"image": imageMale[indexMale], "user": user});
    } else if (indexFemale >= 0) {
      final user = userProvider.user.copyWith(gender: "male");
      Navigator.of(context).pushNamed(AboutMeScreen.routename,
          arguments: {"image": imageFemale[indexFemale], "user": user});
    } else {
      Fluttertoast.showToast(
        msg: "Please select an avatar",
        gravity: ToastGravity.TOP,
        fontSize: 16.sp,
      );
    }
  }
}
