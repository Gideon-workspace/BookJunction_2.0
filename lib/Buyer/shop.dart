import 'package:bookjunction2_0/Buyer/Bsetting.dart';
import 'package:bookjunction2_0/Buyer/bookDetails.dart';
import 'package:bookjunction2_0/Buyer/cart.dart';
import 'package:bookjunction2_0/Buyer/confirmation.dart';
import 'package:bookjunction2_0/Buyer/transaction.dart';
import 'package:bookjunction2_0/components/book_tile.dart';
import 'package:bookjunction2_0/model/store.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../model/books.dart';
import '../repository/authentication_repository/authentication_repo.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Books> books = [];
  List<Books> filteredBooks = [];
  bool isLoading = false;
  TextEditingController _searchcontroller = TextEditingController();
  final  _auth = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }



  Future<void> fetchBooks() async {
    try {
      setState(() {
        isLoading = true;  // Set loading to true to show the loading spinner
      });

      final response = await Supabase.instance.client
          .from('Products')
          .select('product_name,seller_id, price, quantity, image_cover, image_1, image_2, image_3, university');

      print('Supabase response: $response');

      if (response != null) {
        setState(() {
          books = response.map((item) => Books(
            name: item['product_name'],
            id: item['seller_id'],
            price: item['price'].toString(),
            quantity: item['quantity'].toString(),
            imagePath: item['image_cover'],
            image1: item['image_1'],
            image2: item['image_2'],
            image3: item['image_3'],
            university: item['university'],
          )).toList();
          isLoading = false;  // Once data is fetched, set loading to false
        });
        filteredBooks = books;

      } else {
        print('Error fetching books');
        setState(() {
          isLoading = false;  // Set loading to false if there's an error
        });
      }
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;  // Set loading to false in case of an exception
      });
    }
  }



  void signOut(){
    _auth.signOut();
    Navigator.of(context).push(CustomPageRoute(child: const Welcome()));
  }



  void navigate(int index){
    //final cart = context.read<Store>();
   // final books = cart.books;
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Bookdetails(book:books[index],)));

  }

  void searchBooks(String keyword) {
    setState(() {
      filteredBooks = books
          .where((book) =>
          book.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();

      // Show snackbar if no match
      if (filteredBooks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No books found with the given keyword!'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // i can access the cart class anywhere in the app
    // store = context.read<Store>();
    //final books = store.books;
    //store.fetchBooks();
    
    var screenSize = MediaQuery.of(context).size;

    double screenWidth = MediaQuery.of(context).size.width;
    // Define dynamic padding and text sizes based on screen width
    double imageWidth = screenWidth * 0.2;
    double fontSizeTitle = screenWidth * 0.05;

    return WillPopScope(

      onWillPop: ()async{
      //show a confrimation dialog
        bool shouldLogout = await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title:  Text("Confirm Logout",
                  style: GoogleFonts.abel(fontSize: 20,fontWeight:FontWeight.bold),
                ),
                content: const Text("Are you sure you want to log out?",
                style: TextStyle(
                    fontSize: 12,
                ),
                ),
                actions: <Widget>[
                  TextButton(onPressed:(){
                    Navigator.of(context).pop(false); //remain
                  },
                      child:  Text("Cancel",style: GoogleFonts.abel(fontWeight:FontWeight.bold,
                      color: Colors.red,
                      ),
                      ),
                  ),
                  TextButton(onPressed:(){
                    Navigator.of(context).pop(true); //remain
                  },
                    child:  Text("Logout",style: GoogleFonts.abel(fontWeight:FontWeight.bold,
                      color: Colors.green
                      ),
                    ),
                  ),

                ],
              );
            }
        );

        if(shouldLogout){
          signOut();
          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'BookJunction',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(image: AssetImage('assets/student.jpeg'),
                  fit: BoxFit.fill)
                ),
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.home,size: 27,),
                title:  Text('Home',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.history,size: 27,),
                title:  Text('Transaction',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Records()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.shopping_cart,size: 30,),
                title:  Text('Cart',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cart()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.book,size: 30,),
                title:  Text('Confirm',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Confirmation()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.user_cog,size: 27,),
                title:  Text('Profile Settings',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BuyerProfile()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.alternate_sign_out,size: 27,),
                title:  Text('Log Out',style: GoogleFonts.abel(fontSize: 18),),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: TextField(
                    controller: _searchcontroller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(width: 0),
                      ),
                      hintText: 'Search your Textbook',
                      prefixIcon: const Icon(Icons.search, size: 35),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchcontroller.clear();
                          searchBooks('');
                        },
                      ),
                    ),
                    onChanged:
                      searchBooks, // Call the search function with the new value
                  ),

                ),
                const SizedBox(height: 35),
                Container(
                  width: screenSize.width*0.95,
                  height: screenSize.height*0.2,
                  padding: const EdgeInsets.only(
                      top: 8, left: 12, right: 16, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.00,),
                        child: Text(
                          'Find Your course',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                       padding: EdgeInsets.only(left: screenSize.width*0.1, top: screenSize.height*0.03),
                        child: Text(
                          'Textbook',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.55, top: screenSize.height*0.1),
                        child: Text(
                          'At Lower Prices!!!!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.3, top: screenSize.height*0.1),
                        child: Image.asset(
                          'assets/law.png',
                          width: imageWidth,
                          height: screenSize.width*0.13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width, top: screenSize.height*0.12),
                        child: Image.asset(
                          'assets/dna.png',
                          width: imageWidth,
                          height: screenSize.width*0.13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.05, top: screenSize.height*0.06),
                        child: Image.asset(
                          'assets/electronics.png',
                          width: imageWidth,
                          height: screenSize.width*0.13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.55),
                        child: Image.asset(
                          'assets/bookshelf.png',
                         width: imageWidth,
                          height: screenSize.width*0.2,
                        ),
                      ),
                      Padding(
                       padding: EdgeInsets.only(left: screenSize.width*0.0, top: screenSize.height*0.125),
                        child: Image.asset(
                          'assets/pill.png',
                         width: imageWidth,
                          height: screenSize.width*0.1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.15, top: screenSize.height*0.11),
                        child: Image.asset(
                          'assets/tooth.png',
                         width: imageWidth,
                          height: screenSize.width*0.11,
                        ),
                      ),
                      Padding(
                       padding: EdgeInsets.only(left: screenSize.width*0.3, top: screenSize.height*0.04),
                        child: Image.asset(
                          'assets/maths.png',
                          width: imageWidth,
                          height: screenSize.width*0.13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width*0.7),
                  child: const Text(
                    'Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),


                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width*0.04),
                        child: GestureDetector(
                          onTap: () {
                            // Trigger the search functionality
                            searchBooks('Biology');

                            // Clear the search field after a 2-second delay
                            Future.delayed(const Duration(milliseconds: 2), () {
                              _searchcontroller.clear(); // Clear the search controller
                              setState(() {
                                filteredBooks = books; // Reset the filteredBooks list
                              });
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 70,
                            decoration: ShapeDecoration(
                              color: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                                  child: Image.asset('assets/dna.png'),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(top: 15.0, left: 70),
                                  child: Text(
                                    'Health Sciences',
                                    style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Trigger the search functionality
                            searchBooks('Engineering');

                            // Clear the search field after a 2-second delay
                            Future.delayed(const Duration(milliseconds: 2), () {
                              _searchcontroller.clear(); // Clear the search controller
                              setState(() {
                                filteredBooks = books; // Reset the filteredBooks list
                              });
                            });
                          },                        child: Container(
                            width: 150,
                            height: 70,
                            decoration: ShapeDecoration(
                              color:  Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Image.asset('assets/electronics.png'),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(top: 15.0, left: 70),
                                  child: Text(
                                    'Engineering',
                                    style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Computer Science');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color: Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:0,left: 0),
                                    child: Image.asset('assets/computer.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:15.0,left:75),
                                      child: Text('Computer Sciences',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Trigger the search functionality
                            searchBooks('Mathematics');

                            // Clear the search field after a 2-second delay
                            Future.delayed(const Duration(milliseconds: 2), () {
                              _searchcontroller.clear(); // Clear the search controller
                              setState(() {
                                filteredBooks = books; // Reset the filteredBooks list
                              });
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 70,
                            decoration: ShapeDecoration(
                              color: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 10),
                                  child: Image.asset('assets/maths1.png'),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(top: 25.0, left: 80),
                                  child: Text(
                                    'Maths',
                                    style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Physics');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color: Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:10.0,left: 20),
                                    child: Image.asset('assets/physics1.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:80),
                                      child: Text('Physics',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Law');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color: Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:10.0,left: 20),
                                    child: Image.asset('assets/law1.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:85),
                                      child: Text('Law',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Accounting');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color:Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:10.0,left: 5),
                                    child: Image.asset('assets/accounting.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:65),
                                      child: Text('Accounting',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Economics');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color:Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:10.0,left: 20),
                                    child: Image.asset('assets/economics.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:70),
                                      child: Text('Economics',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Chemistry');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color:Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:10.0,left: 20),
                                    child: Image.asset('assets/chemistry.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:70),
                                      child: Text('Chemisty',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('Business');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color: Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:0.0,left: 10),
                                    child: Image.asset('assets/busines.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:75),
                                      child: Text('Business',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Trigger the search functionality
                                searchBooks('History');

                                // Clear the search field after a 2-second delay
                                Future.delayed(const Duration(milliseconds: 2), () {
                                  _searchcontroller.clear(); // Clear the search controller
                                  setState(() {
                                    filteredBooks = books; // Reset the filteredBooks list
                                  });
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,

                                decoration: ShapeDecoration(
                                  color: Colors.yellow,
                                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                child:Stack(
                                  children: [
                                    Padding(padding:const EdgeInsets.only(top:5.0,left: 10),
                                    child: Image.asset('assets/history.png'),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:25.0,left:75),
                                      child: Text('History',style: GoogleFonts.abel(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ) ,
                              ),
                            ),
                          ),


                    ],
                  ),
                ),
                const SizedBox(height: 35),
                 Padding(
                  padding: EdgeInsets.only(right: screenSize.width*0.48),
                  child: const Text(
                    'Available Textbooks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
                isLoading
                    ?  Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenSize.height*0.1),
                    child: CircularProgressIndicator(color: Colors.black,),
                  ),
                )
                :ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return BookTile(book: filteredBooks[index], onTap: ()=>navigate(index),);
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
