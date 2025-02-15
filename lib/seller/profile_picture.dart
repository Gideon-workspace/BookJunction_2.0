import 'dart:io';
import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/seller/dashboard.dart';
import 'package:bookjunction2_0/seller/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import '../features/animations/page_transition.dart';

class Picture extends StatefulWidget {
  const Picture({super.key});

  @override
  _PictureState createState() => _PictureState();
}

class _PictureState extends State<Picture> {
  bool loading = false;
  File? _selectedImage; // Declare the selected image variable

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Update selected image
      });
    }
  }

  // Upload image to Supabase storage
  Future<String?> uploadImage(File file) async {
    try {
      // Define file path dynamically
      final String filePath = 'uploads/profile_picture${DateTime.now().toIso8601String()}.jpg';

      // Upload the image to Supabase storage
      final storage = Supabase.instance.client.storage.from('bookjunction');
      final response = await storage.upload(filePath, file);

      // If the upload is successful, get the public URL
      if (response!=null) {
        final String publicUrl = storage.getPublicUrl(filePath);
        return publicUrl;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Save the image URL to Supabase database
  Future<void> saveImageUrlToDatabase(String imageUrl) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('Sellers').update({
          'profile_picture': imageUrl,
        }).eq('User_ID', user.id);
      }
      if (user != null) {
        await Supabase.instance.client.from('Buyers').update({
          'profile_picture': imageUrl,
        }).eq('User_ID', user.id);
      }
    } catch (e) {
      print("Error saving image URL: $e");
    }
  }

  // Add product and update profile picture
  void Update() async {
    if (_selectedImage == null) {
      floatingSnackBar(
        message: 'No image selected',
        context: context,
        textColor: Colors.red,
        textStyle: const TextStyle(color: Colors.red, fontSize: 16),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.white70,
      );
      return;
    }
    setState(() {
      loading = true; // Start loading
    });

    String? imageUrl = await uploadImage(_selectedImage!);
    if (imageUrl != null) {
      await saveImageUrlToDatabase(imageUrl);
      floatingSnackBar(
        message: 'Profile Picture Updated',
        context: context,
        textColor: Colors.green,
        textStyle: const TextStyle(color: Colors.green, fontSize: 16),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.white70,
      );

      // Navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    }
    setState(() {
      loading = false; // Stop loading after the process is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (loading) {
      return Loading2(); // Display loading screen while uploading
    } else {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).push(CustomPageRoute(child:  Profile()));
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title:  Padding(
              padding:  EdgeInsets.only(left: screenSize.width*0.13),
              child: Text("Upload Image", style: GoogleFonts.abel(fontSize: 25),),
            ),
          ),
          body: Padding(
            padding:  EdgeInsets.only(left: screenSize.width*0.23,top: screenSize.height*0.2),
            child: Column(
              children: [
                 Text(
                  'Update your Profile Picture',
                  style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildImageUploadButton(screenSize),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: Update,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,

                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),
                    ),

                  ),
                  child:  Text('Save Profile Picture', style: GoogleFonts.abel(fontSize: 19),),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Image upload button widget for a single image
  Widget _buildImageUploadButton(Size screenSize) {
    return Column(
      children: [
        IconButton(
          onPressed: () => _pickImage(ImageSource.gallery), // Single image picker
          icon: const Icon(Icons.add_a_photo),
        ),
        if (_selectedImage != null) // Check if an image is selected
          Image.file(
            _selectedImage!,
            width: screenSize.width * 0.6,
            height: 200,
            fit: BoxFit.cover,
          ),
        // Remove button on top of the image
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
