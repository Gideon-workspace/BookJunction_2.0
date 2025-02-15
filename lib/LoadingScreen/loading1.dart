import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading1 extends StatelessWidget {
  const Loading1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitChasingDots(
            color: Colors.green,
            size: 30.0,
          ),
          const SizedBox(height: 10), // Add spacing between spinner and text
          const Text(
            "Loading, please wait...",
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w300,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
