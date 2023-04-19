import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:sizer/sizer.dart';

List<String> desList = [
  "Music junkie seeking a concert buddy to rock out with",
  "Cinephile hoping to find someone to discuss movies with",
  "Outdoor explorer searching for a trailblazing partner",
  "Foodie on the hunt for a fellow gastronome to dine with",
  "Wanderlust traveler in search of an adventure companion",
  "Sports aficionado seeking a fellow fan to watch games with",
  "Fitness fanatic seeking a workout warrior to sweat with",
  "Culture seeker seeking an art lover to explore museums with",
  "Bookworm seeking a reading partner for cozy evenings in",
  "Gamer looking for a gaming buddy for virtual adventures",
  "Humanitarian looking for a charity partner to make a difference",
  "Polyglot seeking a language exchange partner to practice with",
  "Shutterbug seeking a photography buddy to capture memories with",
  "Animal admirer hoping to find a pet-friendly friend for furry fun",
  "Night owl seeking a fellow night owl to chat with late into the night",
  "Early riser seeking a morning person to exercise with",
  "Entrepreneur hoping to find a business-minded buddy to network with",
  "Oenophile seeking a fellow wine enthusiast for tasting adventures",
  "Fashionista seeking a shopping companion to hunt for style steals",
  "Spiritual seeker looking for a like-minded friend for mindful moments",
  "Musician seeking a jam session buddy to make beautiful music with",
  "Comedy fan looking for a fellow humor enthusiast to share laughs with",
  "Karaoke superstar seeking a singing partner to belt out tunes with",
  "Dancer hoping to find a dance partner to groove with",
  "Yogi seeking a yoga buddy to stretch and unwind with",
  "Coffee aficionado seeking a coffee shop companion to savor a cup with",
  "Green thumb looking for a fellow gardener to share tips and plants with",
  "DIY lover seeking a crafting companion for creative projects",
  "Film buff seeking a fellow movie lover to debate the classics with",
  "Social butterfly seeking a friendly face to share new experiences with"
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
                  onScrolled: (val) {
                    if (selected && val == val!.toInt()) {
                      widget
                          .onPressed(selected ? slides[val.toInt()].title : '');
                      setState(() {});
                    }
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  selectedText = slides[realIndex].title;
                  return Center(
                    child: Text(
                      slides[index].title,
                      style: TextStyle(
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
