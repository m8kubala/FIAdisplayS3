import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'constants.dart';
import 'input_screen.dart';
import 'dart:async';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<BluetoothDevice> devices = [];
  bool isScanning = false;
  bool isConnecting = false;
  StreamSubscription<List<ScanResult>>? scanSubscription;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void scanForDevices() {
    FlutterBluePlus.stopScan();
    setState(() {
      devices.clear();
      isScanning = true;
    });

    scanSubscription?.cancel();
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      final foundDevices = results
          .map((r) => r.device)
          .where((d) => d.name.isNotEmpty && d.name.startsWith(kDeviceNamePrefix))
          .toSet()
          .toList();

      setState(() {
        devices = foundDevices;
      });
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5)).whenComplete(() {
      if (mounted) {
        setState(() => isScanning = false);
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    setState(() => isConnecting = true);
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();

      BluetoothCharacteristic? targetCharacteristic;
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() ==
              kTargetCharacteristicUUID.toLowerCase()) {
            targetCharacteristic = characteristic;
            break;
          }
        }
        if (targetCharacteristic != null) break;
      }

      if (targetCharacteristic != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputScreen(
              device: device,
              characteristic: targetCharacteristic!, // <-- add '!'
              deviceName: device.name,
            ),
          ),
        );
      } else {
        showError("No valid characteristic found.");
      }
    } catch (e) {
      showError("Connection failed: $e");
    } finally {
      if (mounted) {
        setState(() => isConnecting = false);
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚨 $message"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Select FIA Display", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: isScanning ? null : scanForDevices,
          ),
        ],
      ),
      body: isConnecting
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (isScanning)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "🔍 Scanning for FIA Displays...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          Expanded(
            child: devices.isEmpty
                ? Center(
              child: Text(
                "No devices found",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name, style: TextStyle(color: Colors.white)),
                  subtitle: Text(device.id.toString(), style: TextStyle(color: Colors.grey)),
                  onTap: () => connectToDevice(device),
                  trailing: Icon(Icons.bluetooth, color: Colors.blue),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
