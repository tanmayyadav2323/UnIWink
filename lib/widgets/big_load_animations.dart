import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BigLoadAnimations extends StatefulWidget {
  const BigLoadAnimations({super.key});

  @override
  State<BigLoadAnimations> createState() => _BigLoadAnimationsState();
}

class _BigLoadAnimationsState extends State<BigLoadAnimations> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/animations/big_loading.json',),
    );
  }
}
