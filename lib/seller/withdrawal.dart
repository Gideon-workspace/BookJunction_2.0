import 'package:bookjunction2_0/seller/getmoney.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../welcome.dart';

class Withdrawal extends StatefulWidget {
  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  String balance = ""; // Set initial balance
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void>fetchData()async{

    try{
      final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;

      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .select('available_money')
            .eq('User_ID',user.id)
            .single();

        if(response!=null && response['available_money'] !=null){
          setState(() {
            balance = response['available_money'];

          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('balance', balance);
          print('money availabe ::${balance}');
        }
      }
    }catch(e){
      print('Failed to fecth data');
    };
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.0),
            child: Text(
              'Withdrawal',
              style: GoogleFonts.abel(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.1),
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.2,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.black,
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, right: screenSize.width * 0.2),
                      // Update this amount dynamically
                      child: Text(
                        'Balance: R$balance',
                        style: GoogleFonts.abel(
                            fontSize: 26, fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.1),
          Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.2, left: screenSize.width * 0.1),
            child: Container(
              width: screenSize.width * 0.8,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(CustomPageRoute(child: const WithdrawCash()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start Withdrawal Process',
                  style: GoogleFonts.abel(fontSize: 19),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
