import 'dart:convert';
import 'dart:io';
import 'package:bookjunction2_0/LoadingScreen/loading4.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:bookjunction2_0/seller/home.dart';
import 'package:bookjunction2_0/seller/withdrawal.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import 'dashboard.dart';

class WithdrawCash extends StatefulWidget {
  const WithdrawCash({super.key});

  @override
  _WithdrawCashState createState() => _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String name ="";
  String balance = "";
  String balance2 = "";


  // Email Validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email pattern validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // If valid
  }

  // Amount Validator
  String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the amount you want to withdraw';
    }
    // Check if the input is a valid number
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    // Check if the amount is greater than 0
    if (double.tryParse(value)! <= 0) {
      return 'Amount must be greater than 0';
    }
    return null; // If valid
  }

  void sendBoughtEmail(String sellerEmail, String bookName, String bookPrice, String buyerContact, String buyerName) async {
    String username = name;
    String password = 'piuz pvgd ewra wphf';
    final purchaseDate = DateTime.now();
    double Availbalance = double.tryParse(balance2) ?? 0.0;
    double Totalbalance = double.tryParse(balance) ?? 0.0;
    double profit = Totalbalance - Availbalance;

    // Define SMTP server
    final smtpServer = gmail(username, password);

    // Create the email message
    final message = Message()
      ..from = Address(username, name)
      ..recipients.add('bookjunction1000@gmail.com')
      ..subject = '${name} Withdrawed Cash'
      ..html = """
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="text-align: center; margin-bottom: 20px;">
       <strong>Profit to be withdrawn from ${name} Account :</strong> 
       <strong>Date ${purchaseDate} :</strong> 
      </div>
    </body>
    </html>
    """
    // Attach the image with a Content-ID
        ;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } catch (e) {
      print('Message not sent. Error: $e');
    }
  }


  Future<void>fetchData()async{

    try{
      // this is for firebase final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;


      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .select('firstname,total_amount,available_money')
            .eq('User_ID',user.id)
            .single();

        if(response!=null && response['available_money'] !=null){
          setState(() {
            balance = response['available_money'];
            balance2 = response['total_amount'];
            name = response['firstname'];

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

  Future<void>DeductMoney()async{

    try{
      // this is for firebase final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;

      double balance = double.tryParse(balance2) ?? 0.0;
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      double new_Balance = balance - amount;
      final user = Supabase.instance.client.auth.currentUser;


      String newBalance = new_Balance.toStringAsFixed(2);
      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .update({
          'total_amount':newBalance
            })
            .eq('User_ID',user.id)
            .single();

        print('total amounted updated');
      }
    }catch(e){
      print('Failed to fecth data');
    };
  }

  //I need to use correct keys (use real account) when I push it to production

  Future<String> getAccessToken(String clientId, String secretKey) async {
    loading = true;
    final url = Uri.parse('https://api.paypal.com/v1/oauth2/token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + base64.encode(utf8.encode('$clientId:$secretKey')),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  /*Future<void> submitWithdrawalRequest(String email, double amount) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client.from('WithdrawalRequests').insert({
          'user_id': user.id,
          'email': email,
          'amount': amount,
          'status': 'Pending',
          'created_at': DateTime.now().toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Withdrawal request submitted for approval.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request: $e')),
        );
      }
    }
  }*/

  //I need to use correct (use real account) when I push it to production

  Future<void> startWithdrawal(String accessToken, String recipientEmail, double amount) async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse('https://api.paypal.com/v1/payments/payouts');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "sender_batch_header": {
          "email_subject": "You have a Payout!",
        },
        "items": [
          {
            "recipient_type": "EMAIL",
            "amount": {
              "value": amount.toString(),
              "currency": "USD"
            },
            "receiver": recipientEmail,
            "note": "Payment for services",
          }
        ],
      }),
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      var batchStatus = data['batch_status'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            batchStatus == 'PENDING'
                ? 'Withdrawal is pending. Please check your PayPal account later.'
                : 'Withdrawal Process Initiated. Please check your PayPal account',
            style: GoogleFonts.abel(fontSize: 16),
          ),
          backgroundColor: batchStatus == 'PENDING' ? Colors.orange : Colors.green,
        ),
      );

      Navigator.of(context).push(CustomPageRoute(child: Home()));
      _emailController.clear();
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending payout: ${response.body}', style: GoogleFonts.abel()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return loading
        ? const Loading4()
        : Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    'Withdraw',
                    style: GoogleFonts.abel(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                  Image.asset(
                    'assets/paypal.png',
                    height: screenSize.height * 0.18,
                    width: screenSize.width * 1,
                  ),
                  const SizedBox(height: 100),
                  Text(
                    'Enter your paypal email',
                    style: GoogleFonts.abel(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.09,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.envelope,
                          size: 35,
                        ),
                      ),
                      validator: emailValidator,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Amount to withdraw',
                    style: GoogleFonts.abel(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.09,
                    ),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Eg. 500.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.coins,
                          size: 35,
                        ),
                      ),
                      validator: amountValidator,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: screenSize.width * 0.5,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: ElevatedButton(
                      onPressed: () async {

                        double amount = double.tryParse(_amountController.text) ?? 0.0;
                        double currentBalance = double.tryParse(balance) ?? 0.0;

                        if(amount <= currentBalance){
                          String clientId =
                              "AdQaRUmbvLszbJRO8eS6VdiEgU38-2LnNGEwpjVIziQS7iEZDifQYDxCGMrP0G8ddpsBVeAoxwgH39nk";
                          String secretKey =
                              "EKksAvlsjmiGvpHdrT2WVHSPPcedG6Jg6XQVViyI2LxfLKeGcQLg__Kfvcp7VyBW7Va__6TGvHlm19XP";
                          String accessToken =
                          await getAccessToken(clientId, secretKey);
                          await startWithdrawal(
                              accessToken,
                              _emailController.text.trim(),
                              double.tryParse(
                                  _amountController.text.trim()) ??
                                  0.0);
                          DeductMoney();
                        }else{
                          floatingSnackBar(
                            message: 'Insufficient Amount',
                            context: context,
                            textColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.red, fontSize: 14),
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.white70,
                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Withdraw',
                        style: GoogleFonts.abel(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
