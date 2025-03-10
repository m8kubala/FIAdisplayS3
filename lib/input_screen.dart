import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  final String deviceName;
  InputScreen({required this.deviceName});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String inputText = "";

  void handleInput(String value) {
    setState(() {
      if (value == "CLR") {
        inputText = "";
      } else if (value == "ENTER") {
        if (inputText.isEmpty) {
          print("Send: CLR");
        } else {
          print("Send: TXT=$inputText");
        }
      } else if (inputText.length < 3) {
        inputText += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "CLR", "0", "ENTER"];

    return Scaffold(
      appBar: AppBar(title: Text(widget.deviceName)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(inputText, style: TextStyle(fontSize: 48)),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => handleInput(keys[index]),
                child: Card(
                  child: Center(child: Text(keys[index], style: TextStyle(fontSize: 24))),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
