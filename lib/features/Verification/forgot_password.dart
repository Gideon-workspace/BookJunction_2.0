import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../animations/page_transition.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Function to handle sending the password reset email then navigate to OTP screen
  void sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        /*await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );*/
         await Supabase.instance.client.auth
            .resetPasswordForEmail(_emailController.text.trim());
        //snake bar to say acounted creayed now sign in
        floatingSnackBar(
          message: 'Password reset email has been sent',
          context: context,
          textColor:  Colors.green,
          textStyle:  const  TextStyle(color:  Colors.green,fontSize: 14),
          duration:  const  Duration(milliseconds:  4000),
          backgroundColor:  Colors.white70,
        );
        Navigator.of(context).push(CustomPageRoute(child: const Welcome()));

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
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                  Image.asset(
                    'assets/password.png',
                    height: screenSize.height * 0.18,
                    width: screenSize.width * 1,
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    'Enter your email to reset your password',
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          LineAwesomeIcons.envelope,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: screenSize.width * 0.5,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: ElevatedButton(
                      onPressed: sendEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Send Email',
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
