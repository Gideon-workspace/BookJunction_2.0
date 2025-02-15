import 'package:bookjunction2_0/Registeration.dart';
import 'package:bookjunction2_0/features/animations/page_transition.dart';
import 'package:bookjunction2_0/signAs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<Welcome> {
  //final _formKey = GlobalKey<FormState>();

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
        body: Center(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: screenSize.width * 0.5 - 180,
                  top: screenSize.height * 0.05,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: screenSize.width * 0.27),
                        child:Image.asset(
                          'assets/person.png',
                          height: screenSize.height*0.5,
                          width: screenSize.width,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: Container(
                          padding: EdgeInsets.only(right: screenSize.width * 0.25),
                          child: Row(
                            children: [
                              Text(
                                'HELLO THERE!',
                                style: GoogleFonts.aBeeZee(fontSize: 36, fontWeight: FontWeight.bold ),
                              ),
                              const SizedBox(height: 10),
                              Image.asset(
                                'assets/wave.png', // Replace with your image path
                                height: 36, // Match the size with the text
                              )

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: EdgeInsets.only(right: screenSize.width * 0.26),
                        child:  Text(
                          'Welcome to the marketplace of university ',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: screenSize.width * 0.28),// Add some horizontal padding
                        child:  Text(
                          'students a place to buy and resell your',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: screenSize.width * 0.25),// Add some horizontal padding
                        child:  Text(
                          'school textbooks',
                          style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),

                        ),
                      ),

                      const SizedBox(height: 80), // Space between text and input fields


                      Padding(
                        padding:  EdgeInsets.only(right:screenSize.width*0.25),
                        child: Row(
                          children: [
                            Container(
                              width:screenSize.width*0.4,
                              margin:  EdgeInsets.only(right: screenSize.width*0.1),
                              height: 50,
                              child:ElevatedButton(onPressed:(){
                                Navigator.of(context).push(CustomPageRoute(child: const Registeration()));
                              },

                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,

                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 2
                                      )
                                    ),

                                  ),
                                  child:  Text('Sign Up',style: GoogleFonts.abel(fontSize: 18),)
                              ),
                            ),
                            Container(
                              width: screenSize.width*0.4,
                              height: 50,
                              child:ElevatedButton(onPressed:(){
                                Navigator.of(context).push(CustomPageRoute(child: const Signas()));
                              },

                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,

                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(

                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                  ),
                                  child:  Text('Sign In',style: GoogleFonts.abel(fontSize: 18))
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
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

