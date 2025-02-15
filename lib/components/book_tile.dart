import 'package:bookjunction2_0/model/books.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/store.dart';

class BookTile extends StatelessWidget {
  final Books book;
  final void Function()? onTap;

  BookTile({
    super.key,
    required this.book,
    required this.onTap,
  });

  List<Map<String, dynamic>> books = [];
  bool isLoading =false;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    var screenSize = MediaQuery.of(context).size;

     // Define dynamic padding and text sizes based on screen width
    double imageWidth = screenWidth * 0.3;
    double imageHeight = screenWidth * 0.35;
    double fontSizeTitle = screenWidth * 0.05;
    double fontSizePrice = screenWidth * 0.035;
    double fontSizeUniversity = screenWidth * 0.035;


    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.only(left: screenSize.width*0.03, right: screenSize.width*0.03, bottom: screenSize.height*0.01),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color:const Color.fromARGB(255, 221, 235, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  book.imagePath,
                  width: imageWidth,
                  height: imageHeight,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          book.name,
                          style: GoogleFonts.abel(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Center(
      
                        child: Text(
                          
                          'R${book.price} - Quanity: ${book.quantity}',
                          style: GoogleFonts.abel(
                            //fontWeight: FontWeight.bold,
                            fontSize: fontSizePrice,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right:0.0),
                            child: Icon(LineAwesomeIcons.university, size: 16),
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Center(
                              child: Text(
                                book.university,
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize:fontSizeUniversity,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
