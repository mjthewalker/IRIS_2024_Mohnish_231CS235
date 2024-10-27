import 'package:flutter/material.dart';

class LinearLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
          ),
        ],
      ),
    );
  }
}
