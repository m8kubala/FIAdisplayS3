import 'package:flutter/material.dart';
import 'device_list.dart';

void main() {
  runApp(FIAdisplayApp());
}

class FIAdisplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIA Display',
      theme: ThemeData.dark(),
      home: DeviceListScreen(),
    );
  }
}
