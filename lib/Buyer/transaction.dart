import 'dart:convert';

import 'package:bookjunction2_0/Buyer/shop.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repository/authentication_repository/authentication_repo.dart';

class Records extends StatefulWidget{
  @override
  _recordsState createState() => _recordsState();

}

class _recordsState extends State<Records>{
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> productsBought = [];
  bool isLoading =false;
  bool isFetched = false;
  //final  _auth = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }


  Future<void> fetchRecords() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      //final firebaseUid = firebaseUser?.id;
      if (user != null) {
        setState(() {
          isLoading = true;
        });

        final response = await Supabase.instance.client
            .from('Transaction')
            .select('product_name, price, quantity')
            .eq('buyer_id', user.id);

        if (response != null) {
          setState(() {
            productsBought = response; // Store the fetched records in products
          });
          print('Records :${productsBought}');

          // Optionally store the fetched data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('productsBought', jsonEncode(response)); // Store as a JSON string

          // Save a flag in SharedPreferences indicating data was fetched
          prefs.setBool('isFetched', true); // Flag to indicate data was fetched
        } else {
          print('Error fetching records: ${response}');
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state after the operation
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>const Shop()));
          },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Padding(padding: EdgeInsets.only(right: 50),
          child: Center(child: Text('TRANSACTIONS',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),),
      ),

      body:       isLoading
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
                itemCount: productsBought.length,
                itemBuilder: (context, index) {
                  final product = productsBought[index];
                  return Container(
                    //width: screenSize.width * 0.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[20],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                        left: 15, right: 15,bottom: 5),
                    child: ListTile(
                      title: Text(product['product_name'],
                        style: GoogleFonts.abel(fontSize: 21),),
                      trailing: Text(
                        '+R${product['price']}',
                        style: GoogleFonts.abel(fontSize:18,color: Colors.green),
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
    );
  }
}


