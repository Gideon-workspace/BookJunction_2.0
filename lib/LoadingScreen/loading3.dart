import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class Loading3 extends StatelessWidget {
  const Loading3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitCircle(
            color:Colors.black,
            size: 30.0
        ),
      ),

    );
  }
}
