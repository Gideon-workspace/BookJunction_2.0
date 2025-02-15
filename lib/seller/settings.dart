import 'package:bookjunction2_0/seller/profile_picture.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../repository/authentication_repository/authentication_repo.dart';
import '../welcome.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState()=> _ProfileState();
}

class _ProfileState  extends State<Profile>{
  String Firstname = ""; // Default value for name.
  String Lastname = "";
  String userEmail = ""; // Default value for email.
  String Town = "";
  String House_number = "";
  String userprofile_picture = '';
  bool isFetched = false;
  final  _auth = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    loadCachedData();
      fetchProfilePicture();
      isFetched = true;


  }
  Future<void> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedFirstname = prefs.getString('Firstname');
    String? cachedLastname = prefs.getString('Lastname');
    String? cachedUseremail = prefs.getString('userEmail');
    String? cachedTown = prefs.getString('Town');
    String? cachedhouse = prefs.getString('House_number');

    if (cachedFirstname != null) {
      // Use cached data
      setState(() {
        Firstname = cachedFirstname;
        Lastname = cachedLastname!;
        userEmail = cachedUseremail!;
        Town = cachedTown!;
        House_number = cachedhouse!;

      });
    } else {
      fetchUserDetails();
    }
  }



  Future<void> fetchUserDetails() async {
    try {
      // Get the current user.
     // u.User? user = u.FirebaseAuth.instance.currentUser;

      final user = Supabase.instance.client.auth.currentUser;
      //final firebaseUid = firebaseUser?.id;


      if (user != null) {
        // Query the 'Sellers' table for multiple fields.
        final response = await Supabase.instance.client
            .from('Sellers')
            .select('firstname,lastname, student_email, town,house_number') // Select multiple fields.
            .eq('User_ID', user.id)
            .single();

        if (response != null) {
          setState(() {
            Firstname = response['firstname'];  // Update name.
            Lastname = response['lastname'];  // Update name.
            userEmail = response['student_email']; // Update email.
            Town = response['town'];
            House_number = response['house_number'];
            // Update phone.
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('Firstname', Firstname);
          prefs.setString('Lastname', Lastname);
          prefs.setString('userEmail', userEmail);
          prefs.setString('Town', Town);
          prefs.setString('House_number', House_number);
          isFetched = true;

        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void>fetchProfilePicture()async{
    try{

      // this is for firebase final user = Supabase.instance.client.auth.currentUser;
      final user = Supabase.instance.client.auth.currentUser;
      //u.User? user = u.FirebaseAuth.instance.currentUser;

      if (user != null){
        final response = await Supabase.instance.client.from('Sellers')
            .select('profile_picture')
            .eq('User_ID',user.id)
            .single();

        if(response!=null && response['profile_picture'] !=null){
          setState(() {
            userprofile_picture = response['profile_picture'];
          });
          isFetched = true;
        }
      }
    }catch(e){
      print('Error fetching user picture: $e');
    };
  }

  Future<void> updateUserDetails(BuildContext context,String controller,String fieldName) async {
    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('Sellers').update({
          fieldName: controller,
        }).eq('User_ID', user.id);
      }
      floatingSnackBar(
        message: 'Profile Updated',
        context: context,
        textColor: Colors.green,
        textStyle: const TextStyle(color: Colors.green, fontSize: 16),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.white70,
      );
    } catch (e) {
      print("Error updating: $e");
    }
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
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          title:  Center(
            child: Padding(
              padding: EdgeInsets.only(left: screenSize.width*0.03),
              child: Text(
                'Profile Settings',
                style: GoogleFonts.abel(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height*0.02,left:screenSize.width*0.28),
                        child: Center(
                          child: CircleAvatar(
                            radius: 70,
                            //Update this according to the profile picture uploaded
                            backgroundImage: userprofile_picture.isNotEmpty
                                ?NetworkImage(userprofile_picture)
                                :const AssetImage('assets/user.png') as ImageProvider, // this is a placeholder


                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25,left: screenSize.width*0.03),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CustomPageRoute(child: const Picture()));
                      },
                      child:  Text(
                        'Edit profile picture',
                        style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),

                  //I wil just retrieve data from database then update such
                  SizedBox(height: screenSize.height * 0.08),
                  buildProfileRow(context, 'First Name', Firstname),
                  SizedBox(height: screenSize.height * 0.01),
                  buildProfileRow(context, 'Last Name', Lastname),
                  SizedBox(height: screenSize.height * 0.01),
                  buildProfileRow(context, 'Student Email', userEmail),
                  SizedBox(height: screenSize.height * 0.01),
                  buildProfileRow(context, 'Town', Town),
                  SizedBox(height: screenSize.height * 0.01),
                  buildProfileRow(context, 'Apartment no', House_number),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style:  GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(LineAwesomeIcons.angle_right),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController controller = TextEditingController(text: value);
                  return AlertDialog(
                    title: Text(label),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Enter new $label',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          // Here you can handle the save action, e.g., update the state with the new value
                          if(label == 'First Name'){
                            String fieldName = 'firstname';
                            updateUserDetails(context,controller.text.trim(), fieldName);
                          }
                          if(label == 'Last Name'){
                            String fieldName = 'lastname';
                            updateUserDetails(context,controller.text.trim(), fieldName);
                          }
                          if(label == 'Town'){
                            String fieldName = 'town';
                            updateUserDetails(context,controller.text.trim(), fieldName);
                          }
                          if(label == 'Apartment no'){
                            String fieldName = 'house_number';
                            updateUserDetails(context,controller.text.trim(), fieldName);
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }


}
