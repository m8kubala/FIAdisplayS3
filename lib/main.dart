import 'package:flutter/material.dart';
import 'intro_screen.dart';
import 'device_list.dart';
import 'input_screen.dart'; // Not used directly here yet, but ready for route-based navigation

void main() {
  runApp(FIADisplayApp());
}

class FIADisplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/devices': (context) => DeviceListScreen(),
        // InputScreen will be navigated via MaterialPageRoute with arguments
      },
    );
  }
}
