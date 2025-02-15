// ignore_for_file: file_names

import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/repository/authentication_repository/authentication_repo.dart';
import 'package:bookjunction2_0/welcome.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Registeration extends StatefulWidget {
  const Registeration({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Registeration> {

  //access all the functions in our class
  final  _auth = AuthenticationRepository();

  //Used to get content from text fields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _town = TextEditingController();
  final TextEditingController _apartment = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  bool loading = false;



  @override
  void dispose(){
    _emailController.dispose;
    _firstname.dispose;
    _lastname.dispose;
    _passwordController.dispose;
    _contact.dispose;
    _town.dispose;
    _apartment.dispose;
    _universityController.dispose;
    super.dispose();
  }
  //function to register user when pressing create account button plus authentication
  void registerUser(String email, String password) async {
    try {
      // Try to create the user
      final user = await _auth.createUserWithEmailAndPassword(email, password);
      final userId = user!.id;
      if (user != null) {
        // If user is created, add user details
        addUserDetails(
            userId,
            _emailController.text.trim(),
            _firstname.text.trim(),
            _lastname.text.trim(),
            int.parse(_contact.text.trim()),
            _town.text.trim(),
            _apartment.text.trim(),
            _universityController.text.trim()
        );

        floatingSnackBar(
          message: 'Account created successfully! Please Verify through Email',
          context: context,
          textColor:  Colors.green,
          textStyle:  const  TextStyle(color:  Colors.green,fontSize: 14),
          duration:  const  Duration(milliseconds:  4000),
          backgroundColor:  Colors.white70,
        );

        // Navigate to verification screen
        Navigator.push(context, MaterialPageRoute(builder:(context)=>const Welcome()),);
      }
    } catch (e) {
      // Check if error is "email-already-in-use"
      if ( e == 'email-already-in-use') {
        floatingSnackBar(
          message: 'This email is already registered. Please login.',
          context: context,
          textColor: Colors.red,
          textStyle: const TextStyle(color: Colors.red, fontSize: 14),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Colors.white70,
        );
      } else {
        // Handle other errors
        floatingSnackBar(
          message: 'Failed to create an Account. Please try again.',
          context: context,
          textColor: Colors.red,
          textStyle: const TextStyle(color: Colors.red, fontSize: 14),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Colors.white70,
        );
      }
      setState(() => loading = false);
    }
  }


  Future addUserDetails(String userId,String email,String firstname,String lastname,int contact,String town,String apartment,String university) async {


    if (userId == null) {
      print("User UID is null");
      return;
    }

    final response = await Supabase.instance.client.from('Sellers').insert({
      'User_ID': userId,
      'student_email': email,
      'firstname': firstname,
      'lastname': lastname,
      'contact': contact,
      'town': town,
      'house_number': apartment,
      'university': university,
    });
    final response1 = await Supabase.instance.client.from('Buyers').insert({
      'User_ID': userId,
      'student_email': email,
      'firstname': firstname,
      'lastname': lastname,
      'contact': contact,
      'town': town,
      'house_number': apartment,
      'university': university,
    });
    if (response == null && response1 == null ) {
      print("Supabase Error: Data inserted unsuccessfully");
    } else {
      print("Data inserted successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return loading? Loading2(): Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Create An Account',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width*0.0),
                      child: const Text('We automatically create both seller and buyer account for you', style: TextStyle(fontSize: 11),),
                    ),
                    const SizedBox(height: 55),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.6),
                      child: const Text('Student Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.envelope, size: 35),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Validate email format
                          if (!RegExp(r'^\d+@[a-zA-Z]+\.[a-zA-Z]+\.ac\.za$').hasMatch(value)) {
                            return 'Please enter a valid student email (e.g., 12345678@any.ac.za)';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.69),
                      child: const Text('Firstname', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _firstname,
                        decoration: InputDecoration(
                          labelText: 'Enter your firstname',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.user, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter your firstname';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.69),
                      child: const Text('Lastname', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _lastname,
                        decoration: InputDecoration(
                          labelText: 'Enter your lastname',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.alternate_user, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter your lastname';
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.7),
                      child: const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                          prefixIcon: const Icon(LineAwesomeIcons.fingerprint, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter  password';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.73),
                      child: const Text('Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _contact,
                        decoration: InputDecoration(
                          labelText: 'Enter your contact',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.phone, size: 35),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter your contact';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.8),
                      child: const Text('Town', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _town,
                        decoration: InputDecoration(
                          labelText: 'Eg.47 Jamaica Street',
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.city, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter your town name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.47),
                      child: const Text('Apartment number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _apartment,
                        decoration: InputDecoration(
                          labelText: 'Eg. House no 10109',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.building, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter your Apartment number ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width*0.68),
                      child: const Text('University', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenSize.width*0.9,
                      child: TextFormField(
                        controller: _universityController,
                        decoration: InputDecoration(
                          labelText: 'Name of your University in full',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: const Icon(LineAwesomeIcons.university, size: 35),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter the university you attend to ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: screenSize.width*0.9,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            setState(() => loading=true);
                            registerUser(_emailController.text.trim(), _passwordController.text.trim());

                          }
                          // handle register login when button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Create An Account'),
                      ),
                    ),
                    const SizedBox(height: 50),
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
