import 'package:bookjunction2_0/Seller/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../repository/authentication_repository/authentication_repo.dart';
import '../welcome.dart';

class Homepage extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Homepage> {
  String username = '';
  String userprofile_picture = '';
  List<Map<String, dynamic>> products = [];
  bool isLoading =false;
  final  _auth = AuthenticationRepository();


  @override
  void initState() {
    super.initState();
    loadCachedData();
    fetchProfilePicture();
    fetchProduct();
  }



  Future<void> fetchProduct() async {
    try {

      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        isLoading = true;
        final response = await Supabase.instance.client.from('Products')
            .select('product_name,price,quantity')
            .eq('seller_id', user.id);

        if (response != null) {
          setState(() {
            products = response;

          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isFetched', true); // Save the flag in SharedPreferences
          isLoading = false;

        }
      }
    } catch (e) {
      print('Error fetching products: $e');
      isLoading = false;

    }
  }
  Future<void>deleteProduct(String product) async{
    try {
      //u.User? user1 = u.FirebaseAuth.instance.currentUser;
      final user1 = Supabase.instance.client.auth.currentUser;

      if (user1 != null) {
        setState(() {
          products.removeWhere((item)=>item['product_name']==product);

        });
      }
      if (user1 != null) {
        final response = await Supabase.instance.client.from('Products')
            .delete()
            .eq('seller_id', user1.id)
            .eq('product_name', product);

      }
    } catch (e) {
      print('Error fetching products: $e');
    }
}
  Future<void> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedUsername = prefs.getString('username');
    String? cachedpicture = prefs.getString('userprofile_picture');

    if (cachedUsername != null) {
      // Use cached data
      setState(() {
        username = cachedUsername;
        userprofile_picture = cachedpicture!;
      });
    } else {
      fetchData();
      fetchProfilePicture();
    }
  }

  Future<void> fetchData() async {


    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client.from('Sellers')
            .select('firstname')
            .eq('firebase_uid', user.id)
            .single();

        if (response != null && response['firstname'] != null) {
          setState(() {
            username = response['firstname'];
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('username', username);
          isLoading = false;

        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }




  Future<void> fetchProfilePicture() async {
    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client.from('Sellers')
            .select('profile_picture')
            .eq('User_ID', user.id)
            .single();

        if (response != null && response['profile_picture'] != null) {
          setState(() {
            userprofile_picture = response['profile_picture'];
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userprofile_picture', userprofile_picture); // Save the flag in SharedPreferences
          isLoading = false;

        }
      }
    } catch (e) {
      print('Failed to fetch profile picture: $e');
      isLoading = false;
    }
  }




  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    void signOut() {
      _auth.signOut();
      Navigator.of(context).push(CustomPageRoute(child: const Welcome()));
    }

    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Confirm Logout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(fontSize: 12),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            });

        if (shouldLogout) {
          signOut();
          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            // Header Section
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    //Update this according to the profile picture uploaded
                    backgroundImage: userprofile_picture.isNotEmpty
                        ?NetworkImage(userprofile_picture)
                        :const AssetImage('assets/user.png') as ImageProvider,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Hi, $username',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Products Section
            Padding(
              padding: EdgeInsets.only(right: screenSize.width * 0.6),
              child: Text(
                'Your Products',
                style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            isLoading
                ?  Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.height*0.25),
                child: CircularProgressIndicator(color: Colors.black,),
              ),
            )
                : Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          //width: screenSize.width * 0.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                              left: 15, right: 15,bottom: 5),
                          child: ListTile(
                            title: Text(product['product_name'],
                            style: GoogleFonts.abel(fontSize: 18),),
                            subtitle: Text(
                                'Price: R${product['price']} - Quantity: ${product['quantity']}'
                                ,
                                style: GoogleFonts.abel()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () {
                                deleteProduct(product['product_name']);

                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10), // Add some spacing after the list
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Button to add product
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Product()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child:  Text('ADD PRODUCT +',
                      style: GoogleFonts.abel(fontSize: 18)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
