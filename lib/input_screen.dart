import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'dart:async';

class InputScreen extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;
  final String deviceName;

  InputScreen({
    required this.device,
    required this.characteristic,
    required this.deviceName,
  });

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String inputText = "";
  bool isConnected = true;
  StreamSubscription<BluetoothConnectionState>? connectionSubscription;

  @override
  void initState() {
    super.initState();
    monitorConnectionStatus();
  }

  @override
  void dispose() {
    connectionSubscription?.cancel();
    super.dispose();
  }

  void monitorConnectionStatus() {
    connectionSubscription = widget.device.connectionState.listen((BluetoothConnectionState state) {
      if (mounted) {
        setState(() => isConnected = (state == BluetoothConnectionState.connected));
      }
    });
  }

  void disconnectAndGoBack() async {
    try {
      await widget.device.disconnect();
    } catch (e) {
      print("🚨 Error disconnecting: $e");
    }
    setState(() {
      isConnected = false;
    });
    Navigator.pop(context);
  }

  void sendCommand(String command) async {
    try {
      List<int> message = utf8.encode(command);
      await widget.characteristic.write(message, withoutResponse: false);
      print("✅ Sent: $command");
    } catch (e) {
      print("🚨 Error sending BLE command: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Could not send command."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onEnterPressed() {
    if (inputText.isEmpty) {
      sendCommand("CLR");
    } else {
      sendCommand("TXT=$inputText");
    }
    setState(() => inputText = "");
  }

  void onKeyPressed(String key) {
    setState(() {
      if (key == "CLR") {
        inputText = "";
      } else if (key == "ENTER") {
        onEnterPressed();
      } else {
        if (inputText.length < 3) {
          inputText += key;
        }
      }
    });

    // Optional: Haptic feedback on tap
    // HapticFeedback.mediumImpact();
  }

  Widget buildKeypadButton(String text, double buttonSize) {
    return Padding(
      padding: EdgeInsets.all(2.5),
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: ElevatedButton(
          onPressed: () => onKeyPressed(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.grey[800],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text,
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  String getDisplayText() {
    if (inputText.isEmpty) return "---";
    return inputText.padLeft(3, " ");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonSize = screenWidth / 3.6;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.deviceName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: disconnectAndGoBack,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            color: isConnected ? Colors.green : Colors.red,
            child: Center(
              child: Text(
                isConnected
                    ? "🟢 Connected to ${widget.deviceName}"
                    : "🔴 Disconnected!",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              getDisplayText(),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 6,
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        buildKeypadButton("7", buttonSize),
                        buildKeypadButton("8", buttonSize),
                        buildKeypadButton("9", buttonSize),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        buildKeypadButton("4", buttonSize),
                        buildKeypadButton("5", buttonSize),
                        buildKeypadButton("6", buttonSize),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        buildKeypadButton("1", buttonSize),
                        buildKeypadButton("2", buttonSize),
                        buildKeypadButton("3", buttonSize),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        buildKeypadButton("CLR", buttonSize),
                        buildKeypadButton("0", buttonSize),
                        buildKeypadButton("ENTER", buttonSize),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
