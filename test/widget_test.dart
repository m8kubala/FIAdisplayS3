import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiadisplay_s3/device_list.dart'; // Import your device list screen

void main() {
  testWidgets('App UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DeviceListScreen()));

    expect(find.text('Select FIA Display'), findsOneWidget);
  });
}
