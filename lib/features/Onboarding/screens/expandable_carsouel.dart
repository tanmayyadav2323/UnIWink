import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

List<String> desList = [
  "I enjoy reading sci-fi novels, playing video games, and attending comic book conventions. I hope to meet someone who shares my love for geek culture.",
  "I'm passionate about environmental activism, hiking, and trying new plant-based recipes. I'm seeking someone who values sustainability and adventure.",
  "I love listening to jazz music, painting, and visiting museums. I'm looking for a creative partner who enjoys exploring the art world with me.",
  "I'm an avid traveler, language learner, and cultural enthusiast. I want to meet someone who is open to exploring the world and learning about different lifestyles.",
  "I enjoy practicing yoga, mindfulness meditation, and volunteering for mental health advocacy organizations. I'm hoping to find someone who values personal growth and social responsibility.",
  "I'm passionate about entrepreneurship, networking, and attending startup events. I want to meet someone who shares my ambition and drive for success.",
  "I love playing with my pets, gardening, and crafting DIY projects. I'm looking for a partner who shares my love for animals and creativity.",
  "I'm into weightlifting, cooking healthy meals, and learning about nutrition. I want to find someone who prioritizes their health and wellness.",
  "I enjoy watching indie films, attending poetry slams, and volunteering for social justice causes. I'm seeking someone who is passionate about making a positive impact in their community.",
  "I love attending music festivals, trying new cocktail recipes, and exploring the city's nightlife. I hope to find someone who shares my love for fun and spontaneity.",
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

class CarouselView extends StatefulWidget {
  final Function(String) onPressed;

  CarouselView({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  final CarouselController _controller = CarouselController();
  bool selected = false;
  String selectedText = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected = !selected;
        widget.onPressed(selected ? selectedText : '');
        setState(() {});
      },
      child: Container(
        height: 20.h,
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.white.withOpacity(0.6), width: selected ? 2 : 0.5),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Color(0XFF6C6D83),
              Color(0XFF202143),
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
                  color: Color(0XFF9B9B9B),
                  size: 2.h,
                ),
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Expanded(
              child: ExpandableCarousel.builder(
                options: CarouselOptions(
                  showIndicator: false,
                  slideIndicator: null,
                  viewportFraction: 1.0,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: !selected,
                  controller: _controller,
                  restorationId: 'expandable_carousel',
                ),
                itemBuilder: (context, index, realIndex) {
                  selectedText = slides[realIndex].title;
                  return Center(
                    child: Text(
                      slides[index].title,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                itemCount: slides.length,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            GestureDetector(
              onTap: _controller.nextPage,
              child: SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0XFF9B9B9B),
                  size: 2.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
