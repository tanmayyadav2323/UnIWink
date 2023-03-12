import 'package:buddy_go/features/background/bg_screen.dart';
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:buddy_go/config/theme_colors.dart';
import 'package:buddy_go/features/onboarding/screens/about_me_screen.dart';
import 'package:buddy_go/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    "img_1",
    "img_2",
    "img_3",
    "img_4",
    "img_5",
    "img_6",
    "img_7",
    "img_8",
    "img_9",
    "img_1",
    "img_2",
    "img_3",
    "img_4",
    "img_5",
    "img_6",
    "img_7",
    "img_8",
    "img_9",
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
        body: BgScreen(
          centerGradient: false,
          child: Stack(
            children: [
              NestedScrollView(
                physics: ScrollPhysics(parent: PageScrollPhysics()),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      leading: const SizedBox.shrink(),
                      leadingWidth: 0,
                      title: Column(
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            "AI avatar",
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Text(
                              "To keep your identity partially confidential, we introduce your AI Avatar that will represent you in UnIWink ! time to customize one.",
                              maxLines: 3,
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                height: 1.2,
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
                    Container(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      height: double.infinity,
                      width: double.infinity,
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 2.w, right: 2.w, bottom: 20.h, top: 4.h),
                        itemCount: imageMale.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6.w,
                          mainAxisSpacing: 3.h,
                        ),
                        itemBuilder: (context, index) {
                          return Material(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              splashColor: Colors.blue.withOpacity(1),
                              hoverColor: Colors.blue.withOpacity(1),
                              onTap: () {
                                indexFemale = -1;
                                if (indexMale == index) {
                                  indexMale = -1;
                                } else {
                                  indexMale = index;
                                }
                                setState(() {});
                              },
                              child: Container(
                                height: 10.h,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    border: indexMale == index
                                        ? Border.all(color: Colors.white)
                                        : null,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      indexMale == index
                                          ? BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 15,
                                              spreadRadius: 0,
                                            )
                                          : BoxShadow()
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    "assets/images/ai_bimg/${imageMale[index]}.png",
                                    fit: BoxFit.fill,
                                  ),
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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withOpacity(0),
                        backgroundColor.withOpacity(0.8),
                        backgroundColor,
                      ],
                      stops: [0, 0.2, 1],
                    ),
                  ),
                  height: 22.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.5.h,
                      ),
                      CustomButton(
                        buttonText: "Set Avatar",
                        onPressed: saveImage,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -8.h,
                left: 6.w,
                child: Container(
                    height: 20.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/ellipse_gradient.png'),
                        fit: BoxFit.fill,
                      ),
                    )),
              ),
            ],
          ),
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
