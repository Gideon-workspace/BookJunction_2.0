import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';


class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Function to handle sending the password reset email then navigate to OTP screen
  void sendConfirmation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {

        final user = await Supabase.instance.client.auth.currentUser;

        if(user != null){
          print(user.id);

          await Supabase.instance.client.from("Transaction").update({
            'status': "Completed"
          }).eq('buyer_id', user.id)
              .eq('seller_id', _codeController.text.trim())
              .eq('product_name', _nameController.text.trim())
              .eq('price', _priceController.text.trim());

          floatingSnackBar(
            message: 'CONFIRMED!',
            context: context,
            textColor:  Colors.green,
            textStyle:  const  TextStyle(color:  Colors.green,fontSize: 14),
            duration:  const  Duration(milliseconds:  4000),
            backgroundColor:  Colors.white70,
          );

          _codeController.clear();
          _nameController.clear();
          _priceController.clear();

        }else{
          floatingSnackBar(
            message: 'Failed, Check the input details correctly!',
            context: context,
            textColor:  Colors.green,
            textStyle:  const  TextStyle(color:  Colors.green,fontSize: 14),
            duration:  const  Duration(milliseconds:  4000),
            backgroundColor:  Colors.white70,
          );

        }


      } catch (e) {
        floatingSnackBar(
          message: "Error: $e",
          context: context,
          textColor:  Colors.red,
          textStyle:  const  TextStyle(color:  Colors.red,fontSize: 14),
          duration:  const  Duration(milliseconds:  4000),
          backgroundColor:  Colors.white70,
        );
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return loading
        ? const Loading2()
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
                  const Text(
                    'Confirmation of receiving the book',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                  Image.asset(
                    'assets/confirm.png',
                    height: screenSize.height * 0.18,
                    width: screenSize.width * 1,
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    'Name of the book you received',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.09,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.book,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Price of the book',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.09,
                    ),
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.money_check,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text(
                    'The code of the book',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.09,
                    ),
                    child: TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.barcode,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 15),
                  Container(
                    width: screenSize.width * 0.5,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: ElevatedButton(
                      onPressed: sendConfirmation,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16),
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
