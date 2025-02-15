import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Loading4 extends StatelessWidget {
  const Loading4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            color: Colors.green,
            size: 30.0,
          ),
          const SizedBox(height: 10), // Add spacing between spinner and text
           Text(
            "Loading, please wait...",
            style: GoogleFonts.abel(
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
