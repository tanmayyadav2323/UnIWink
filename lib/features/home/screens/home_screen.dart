import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routename = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Sucessfully logged In!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
