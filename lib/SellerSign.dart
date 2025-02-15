import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/repository/authentication_repository/authentication_repo.dart';
import 'package:bookjunction2_0/seller/dashboard.dart';
import 'package:bookjunction2_0/signAs.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Buyer/shop.dart';
import 'features/Verification/forgot_password.dart';
import 'features/animations/page_transition.dart';

class SellerSignIn extends StatefulWidget {
  const SellerSignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SellerSignIn> {
  final  _auth = AuthenticationRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool loading = false;



  void signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        //check if email is in the database
        final response= await Supabase.instance.client
        .from('Sellers')
        .select('student_email')
        .eq('student_email',_emailController.text.trim());

        if(response.isEmpty){
          floatingSnackBar(
            message: 'Email does not exist as Seller.',
            context: context,
            textColor: Colors.red,
            textStyle: const TextStyle(color: Colors.red, fontSize: 14),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: Colors.white60,
          );
          setState(() => loading = false);
          return;
        }

        // Attempt to sign in with Firebase
        await _auth.loginWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // On successful sign-in
        floatingSnackBar(
          message: 'Login Successful!',
          context: context,
          textColor: Colors.green,
          textStyle: const TextStyle(color: Colors.green, fontSize: 14),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: Colors.white60,
        );
        Navigator.of(context).push(CustomPageRoute(child: const Home()));
      }  catch (e) {
        // Specific error handling
        String errorMessage = '';


        // Display the error message to the user
        floatingSnackBar(
          message: 'Login unSuccessful!',
          context: context,
          textColor: Colors.red,
          textStyle: const TextStyle(color: Colors.red, fontSize: 14),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Colors.white60,
        );
        setState(() => loading = false);
      } catch (e) {
        // Handle other potential exceptions
        floatingSnackBar(
          message: 'Unexpected Error, Please Try Again',
          context: context,
          textColor: Colors.red,
          textStyle: const TextStyle(color: Colors.red, fontSize: 14),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Colors.white60,
        );
        setState(() => loading = false);
      }
    } else {
      floatingSnackBar(
        message: 'Invalid credentials',
        context: context,
        textColor: Colors.red,
        textStyle: const TextStyle(color: Colors.red, fontSize: 14),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.white60,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(CustomPageRoute(child: const Signas()));
        return false;
      },
      child: loading? Loading2():Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: screenSize.width,
              child: Form(
                key: _formKey, // Assign form key
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenSize.height * 0.05),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: screenSize.width * 0.0),
                          child: Image.asset(
                            'assets/brain.png',
                            height: screenSize.height * 0.25,
                            width: screenSize.width * 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: screenSize.width * 0.0),
                          child: const Text(
                            'BookJunction',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: EdgeInsets.only(right: screenSize.width * 0.58),
                          child: const Text(
                            'Student Email',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: screenSize.width * 0.9,
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: const Icon(LineAwesomeIcons.envelope, size: 35),
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
                        const SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(right: screenSize.width * 0.68),
                          child: const Text(
                            'Password',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: screenSize.width * 0.9,
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: const Icon(LineAwesomeIcons.fingerprint, size: 35),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: screenSize.width * 0.55),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(CustomPageRoute(child: const ForgotPassword()));

                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: screenSize.width * 0.8,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),


                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
