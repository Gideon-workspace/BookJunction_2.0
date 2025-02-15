// ignore_for_file: file_names
import 'package:bookjunction2_0/Buyer/shop.dart';
import 'package:bookjunction2_0/Buyer/viewpicture.dart';
import 'package:bookjunction2_0/model/books.dart';
import 'package:bookjunction2_0/model/store.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../features/animations/page_transition.dart';


// ignore: camel_case_types
class Bookdetails extends StatefulWidget{

  final Books book;
  const Bookdetails({super.key, required this.book});

  @override
  _BookdetailsState createState()=> _BookdetailsState();
}

// ignore: camel_case_types
class _BookdetailsState extends State<Bookdetails> {
  int selectedQuantity = 1;
  
  void move(String image){ 
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPicture(image: image )));
  }
  
  void addToCart(){
    //grab the shop has everything in it
    final cart = context.read<Store>();
    //adding to customer
    cart.addToCart(widget.book);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        // Automatically close the dialog after 2 seconds
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            Navigator.of(context).push(CustomPageRoute(child: const Shop()));// Close the dialog
          }
        });

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Book added to cart",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/check.png', // Replace with your image path
                width: 100,
                height: 50,// Adjust image width as needed
              ),
            ],
          ),
        );

      },
    );


  }
 

  @override
  Widget build(BuildContext context) {
    
    
    var screenSize = MediaQuery.of(context).size;

    
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(

        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new,size: 18,),
        
         onPressed: () { 
            Navigator.pop(context);

         },),

         title:  Padding(
           padding: EdgeInsets.only(right:screenSize.width*0.15),
           child: Center(child: Text('Book Details',style: GoogleFonts.abel(fontSize: 23,fontWeight: FontWeight.bold),)),
         ),
      ),

      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
        
          children: <Widget>[
        
            Center(
              child: Image.network(widget.book.imagePath),
            ),

            const SizedBox(height: 15),

            Padding(
              padding:  EdgeInsets.only(right:screenSize.width*0.56),
              child: Text(widget.book.name,style: GoogleFonts.abel(fontSize: 27,fontWeight: FontWeight.bold),),
            ),

            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right:screenSize.width*0.0,top: 15,bottom: 10),
                        child: Text('Condition:',style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.bold),) ,
                ),
               
              ],
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () => move(widget.book.image1),
                      child: Image.network(
                        widget.book.image1,
                        width: 100,
                        ),
                    ),
                  ),
                ),

                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () => move(widget.book.image2),
                      child: Image.network(
                        widget.book.image2,
                        width: 100,
                        ),
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () => move(widget.book.image3),
                      child: Image.network(
                        widget.book.image3,
                        width: 100,
                        ),
                    ),
                  ),
                ),
              ],),

              Padding(
                padding: EdgeInsets.only(right:screenSize.width*0.75,top: 30),
                child: const Text('Disclaimer',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 17, 0)),),
              ),

              Padding(
                padding: EdgeInsets.only(left:screenSize.width*0.01,top: 15,bottom: 5),
                child: Text('When you purchase this book contact numbers will be send to student who sells this books so you guys can talk about a place of collection on CAMPUS',style: TextStyle(fontSize: 14),),
              ),
            const SizedBox(height: 15),
            Padding(
              padding:  EdgeInsets.only(right: screenSize.width*0.67),
              child: const Text(
                'Select Quantity:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(right: screenSize.width*0.7),
              child: DropdownButton<int>(
                value: selectedQuantity,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.grey[100], // Background color of dropdown
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black, // Color of the dropdown arrow
                  size: 30,
                ),

                items: List.generate(
                  int.parse(widget.book.quantity), // Convert string to int
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),),

                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedQuantity = value!;
                  });
                },
              ),
            ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('R${widget.book.price}',style: GoogleFonts.abel(fontSize: 24),),
                  ),
                  Container(
                      width: 150,
                      height: 50,
                      margin: EdgeInsets.only(left:screenSize.width*0.3,top: 50,bottom: 50),
                      child:ElevatedButton(
                          onPressed:(){
                            addToCart();
                            print(' ${widget.book.id} added to cart.');

                          },

                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        
                        borderRadius: BorderRadius.circular(5),
                      ),

                      ),
                    child:  Text('ADD TO CART',style: GoogleFonts.abel(fontSize: 16),)
                    ),
                    ),
              ],)

            
        
        
          ],
        
        
        ),
      ),







    );
  }
}