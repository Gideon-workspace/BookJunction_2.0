import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../repository/authentication_repository/authentication_repo.dart';
import '../welcome.dart';

class Dashboard2 extends StatefulWidget{
  const Dashboard2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Dashboard2State createState()=> _Dashboard2State();
  
}

class _Dashboard2State extends State<Dashboard2> {
  String username =''; //default value if data isnt fetched
  String userprofile_picture = '';
  String EarnedCash="";
  String AvailableCash ="";
  List<Map<String, dynamic>> productsBought = [];
  bool isLoading = false;
  List<Map<String, dynamic>> products = [];
  final  _auth = AuthenticationRepository();



  @override
  void initState() {
    super.initState();
    loadCachedData();
    fetchEarnedCash();
    fetchProfilePicture();
    fetchRecords();

  }

  Future<void> fetchRecords() async {
    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        setState(() {
          isLoading = true;
        });

        final response = await Supabase.instance.client
            .from('Transaction')
            .select('product_name, price, quantity')
            .eq('seller_id', user.id)
            .eq('status', "Completed");

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

  Future<void> fetchEarnedCash() async {
    try {
      //u.User? seller = u.FirebaseAuth.instance.currentUser;
      final seller = Supabase.instance.client.auth.currentUser;

      if (seller != null) {
        // Fetch all prices for the seller
        final response = await Supabase.instance.client
            .from('Transaction')
            .select('price')
            .eq('seller_id', seller.id)
            .eq('status', "Completed");

        // Check if the response contains data
        if (response != null) {
          // Calculate the total sum of prices
          double totalEarned = 0.0;
          for (var item in response) {
            totalEarned += (item['price'] as num).toDouble(); // Convert to double
          }

          setState(() {
            EarnedCash = totalEarned.toStringAsFixed(2); // Format as string with two decimal places
          });
          // Save the earned cash value in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('EarnedCash', EarnedCash);

          updateIncome();
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> updateIncome() async {
    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        setState(() {
          isLoading = true;
        });
        double earnedCashDouble = double.tryParse(EarnedCash) ?? 0.0;
        double deductedAmount = earnedCashDouble * 0.10;  // 10% deduction
        double availableCash = earnedCashDouble - deductedAmount;

        // Assign the result to available_cash as string
        AvailableCash = availableCash.toStringAsFixed(2);

        // Perform the update
        final response = await Supabase.instance.client
            .from('Sellers')
            .update({
          'total_amount': EarnedCash,
          'available_money': AvailableCash, // Column to update
        }).eq('User_ID', user.id)
            .select().single();

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('AvailableCash', AvailableCash);
        print('Available Cash after 10% deduction: $AvailableCash');
        if (response != null ) {
          print('updating income: ${response}');
        } else {
          print('No response returned.');
        }
      }
    } catch (e) {
      print('Error updating income: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
      fetchEarnedCash();
      fetchProfilePicture();
    }
  }

  //not just names but also the money made
  Future<void>fetchData()async{

    try{
      // this is for firebase final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;


      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .select('firstname')
            .eq('User_ID',user.id)
            .single();

        if(response!=null && response['firstname'] !=null){
          setState(() {
            username = response['firstname'];

          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('username', username);
        }
      }
    }catch(e){
      print('Failed to fecth data');
    };
  }

  Future<void>fetchProfilePicture()async{
    try{

      // this is for firebase final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;


      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .select('profile_picture')
            .eq('User_ID',user.id)
            .single();

        if(response!=null && response['profile_picture'] !=null){
          setState(() {
            userprofile_picture = response['profile_picture'];
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userprofile_picture', userprofile_picture);
        }
      }
    }catch(e){
      print('Failed to fecth data');
    };
  }
  
  @override
  Widget build(BuildContext context) {

    void signOut(){
      _auth.signOut();
      Navigator.of(context).push(CustomPageRoute(child: const Welcome()));
    }
    var screenSize = MediaQuery.of(context).size;
    
    return WillPopScope(
      onWillPop: () async {
        //show a confrimation dialog
        bool shouldLogout = await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: const Text("Confirm Logout",
                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
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
                    child: const Text("Cancel",style: TextStyle(fontWeight:FontWeight.bold,
                      color: Colors.red,
                    ),
                    ),
                  ),
                  TextButton(onPressed:(){
                    Navigator.of(context).pop(true); //remain
                  },
                    child: const Text("Logout",style: TextStyle(fontWeight:FontWeight.bold,
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
        body:Center(
          child: Column(
            children:<Widget>[

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50,left: screenSize.width*0.069,right: 20),
                    child: CircleAvatar(

                      radius: 40,
                      //Update this according to the profile picture uploaded
                      backgroundImage: userprofile_picture.isNotEmpty
                          ?NetworkImage(userprofile_picture)
                          :const AssetImage('assets/user.png') as ImageProvider,  // this is a placeholder


                    ),
                  ),
                  /// you need to take the user firstname and update it here
                   Padding(
                     padding: const EdgeInsets.only(top:50),
                     child: Text('Hi,' " " '$username',style: const TextStyle(fontSize: 22,),),
                   ),

                ],
                ),

                SizedBox(height: screenSize.height*0.075),
                Container(
                  width: screenSize.width * 0.9,
                  height: screenSize.height*0.27,
                  decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)
                  ),
                  color: Colors.blue,
                  ),

                  child: Stack(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(top: 20,left: screenSize.width * 0.05),
                        child:  Text('Dashboard',style: GoogleFonts.abel(fontSize: 33,fontWeight: FontWeight.bold),),
                      ),

                       Padding(
                        padding: EdgeInsets.only(top: 65,left: screenSize.width * 0.05),
                        //Update this amount accordingly
                         // When product sold charge 5% take its string value and update it here

                        child:  Text('R$EarnedCash',style: GoogleFonts.abel(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white),),
                      ),



                       Padding(
                        padding: EdgeInsets.only(top: 160,left: screenSize.width * 0.05),

                        //Update this amount accordingly
                         //available balance is total balance minus the price
                        child:  Text('Available Balance: R$AvailableCash',style: GoogleFonts.abel(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.white),),
                      ),



                    ],
                  ),


                ),

                SizedBox(height:screenSize.height * 0.05),
                 Padding(
                  padding: EdgeInsets.only(right:screenSize.width*0.48),
                  child:  Text('Transactions:',style: GoogleFonts.abel(fontSize: 26,fontWeight: FontWeight.bold),),
                ),

                //Systematically add name+money showing sold books, this should be inside this consider
                // And make the contents inside this container scrollable
              isLoading
                  ?  Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenSize.height*0.1),
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
            ],

          ),




        ),


      ),
    );
  }
}