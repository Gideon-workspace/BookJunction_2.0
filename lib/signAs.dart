
import 'package:bookjunction2_0/BuyerSign.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SellerSign.dart';
import 'features/animations/page_transition.dart';

class Signas extends StatelessWidget {
  const Signas({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).push(CustomPageRoute(child: const Welcome()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Title Section
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.1,
                  ),
                  child: Text(
                    'Sign In As',
                    textAlign: TextAlign.center,
                    style:GoogleFonts.abel(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Spacer
                SizedBox(height: screenSize.height * 0.2),

                // Seller Button
                Padding(
                  padding: EdgeInsets.only(left:screenSize.width*0.0 ),
                  child: Container(
                    width: screenSize.width * 0.8,
                    height: 60,
                      margin: EdgeInsets.only(right: screenSize.width * 0.0,bottom: screenSize.height*0.07),

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SellerSignIn()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/shop.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 15),
                           Text(
                            'Seller',
                            style: GoogleFonts.abel(fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Buyer Button
                Padding(
                  padding: EdgeInsets.only(left:screenSize.width*0.1 ),
                  child: Container(
                    width: screenSize.width * 0.8,
                    height: 60,
                      margin: EdgeInsets.only(right: screenSize.width * 0.1),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuyerSignIn()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/buyer.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 15),
                           Text(
                            'Buyer',
                            style: GoogleFonts.abel(fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
