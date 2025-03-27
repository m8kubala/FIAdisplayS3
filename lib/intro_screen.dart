import 'package:flutter/material.dart';
import 'constants.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(kSplashDuration, () {
      Navigator.pushReplacementNamed(context, '/devices');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/fiadisplay_intro_screen.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'FIA Display',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            );
          },
        ),
      ),
    );
  }
}
