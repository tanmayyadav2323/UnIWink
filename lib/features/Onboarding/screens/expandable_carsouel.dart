import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

List<String> desList = [
  "“I love sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
  "“I am sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
  "“I you sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
  "“I love sports, parties and watching thriller movies. I wish to find an old school kinda girl to have a interactive and fun party eve”",
];

class Slide {
  Slide({
    required this.title,
    required this.color,
  });

  final Color color;
  final String title;
}

var slides = List.generate(
  desList.length,
  (index) => Slide(
    title: desList[index],
    color: Colors.primaries[index % Colors.primaries.length],
  ),
);

final List<Widget> sliders = slides
    .map(
      (item) => Center(
        child: Text(
          item.title,
          style: GoogleFonts.nunito(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    )
    .toList();

class CarouselView extends StatefulWidget {
  const CarouselView({Key? key}) : super(key: key);

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 0.5),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Color(0XFFC4C4C4).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(13),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0XFF000000).withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _controller.previousPage,
            child: SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 4.h,
              ),
            ),
          ),
          Expanded(
            child: ExpandableCarousel(
              options: CarouselOptions(
                showIndicator: false,
                slideIndicator: null,
                viewportFraction: 1.0,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlay: true,
                controller: _controller,
                restorationId: 'expandable_carousel',
              ),
              items: sliders,
            ),
          ),
          GestureDetector(
            onTap: _controller.nextPage,
            child: SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 4.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
