import 'package:flutter/cupertino.dart';

import 'package:sizer/sizer.dart';

class AnimatedTextFade extends StatefulWidget {
  final String text;

  AnimatedTextFade({required this.text});

  @override
  _AnimatedTextFadeState createState() => _AnimatedTextFadeState();
}

class _AnimatedTextFadeState extends State<AnimatedTextFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SizedBox(
            width: 50.w,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ),
        );
      },
    );
  }
}
