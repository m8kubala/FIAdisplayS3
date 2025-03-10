import 'package:flutter/material.dart';
import 'input_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<String> devices = ["FIAdisplay_001", "FIAdisplay_002"]; // Simulated scan results

  void refreshDevices() {
    setState(() {
      devices = ["FIAdisplay_003", "FIAdisplay_004"]; // Simulated refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select FIA Display'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshDevices,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputScreen(deviceName: devices[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
