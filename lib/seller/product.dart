import 'dart:io';
import 'package:bookjunction2_0/LoadingScreen/loading2.dart';
import 'package:bookjunction2_0/seller/dashboard.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/animations/page_transition.dart';
import '../repository/authentication_repository/authentication_repo.dart';
import '../welcome.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final  _auth = AuthenticationRepository();
  File? _coverImage;
  File? _image1;
  File? _image2;
  File? _image3;
  bool loading = false;
  String university = '';


  // Controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Function to handle image selection
  Future<void> _pickImage(ImageSource source, String fieldName) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final pickedFile = File(pickedImage.path);

      setState(() {
        if (fieldName == 'image_cover') {
          _coverImage = pickedFile; // Update cover image
        } else if (fieldName == 'image_1') {
          _image1 = pickedFile; // Update first image
        } else if (fieldName == 'image_2') {
          _image2 = pickedFile; // Update second image
        } else if (fieldName == 'image_3') {
          _image3 = pickedFile; // Update third image
        }
      });
    }
  }

  // Function to upload the images to Supabase storage and save the URL
  Future<String?> uploadImage(File file, String fieldName) async {
    try {
      // Define file path dynamically
      final String filePath = 'uploads/${fieldName}_${DateTime.now().toIso8601String()}.jpg';

      // Upload the image
      final storage = Supabase.instance.client.storage.from('bookjunction');
      await storage.upload(filePath, file);

      // Get the public URL
      final String publicUrl = storage.getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Function to save the image URL in the database
  Future<void> saveImageUrlToDatabase(String imageUrl, String fieldName) async {
    try {
      //u.User? user = u.FirebaseAuth.instance.currentUser;
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        await Supabase.instance.client.from('Products').update({
          fieldName: imageUrl,
        }).eq('seller_id', user.id)
            .eq('product_name',_nameController.text.trim());
      }
    } catch (e) {
      print("Error saving image URL: $e");
    }
  }

  Future<void> fetchData() async {
    try {

      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client.from('Sellers')
            .select('university')
            .eq('User_ID', user.id)
            .single();
        if (response != null && response['university'] != null) {
          setState(() {
            university = response['university'];
          });


        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  // Function to add the product to the database
  void addProduct() async {
    if (_coverImage == null) {
      floatingSnackBar(
        message: 'Please upload a cover image!',
        context: context,
        textColor: Colors.red,
        textStyle: const TextStyle(color: Colors.red, fontSize: 14),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.white70,
      );
      return;
    }
    if (_image1 == null || _image2 == null || _image3 == null) {
      floatingSnackBar(
        message: 'Please upload all required images!',
         context: context,
         textColor: Colors.red,
         textStyle: const TextStyle(color: Colors.red, fontSize: 14),
         duration: const Duration(milliseconds: 2000),
         backgroundColor: Colors.white70,
      );
       return;
  }
    setState(() {
      loading = true; // Start loading
    });

    final user1 = Supabase.instance.client.auth.currentUser;

    if (user1 == null) {
      floatingSnackBar(
        message: 'No user logged in!',
        context: context,
        textColor: Colors.red,
        textStyle: const TextStyle(color: Colors.red, fontSize: 14),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.white70,
      );
      return;
    }

    final productResponse = await Supabase.instance.client.from('Products').insert({
      'product_name': _nameController.text.trim(),
      'price': _priceController.text.trim(),
      'quantity': _quantityController.text.trim(),
      'seller_id': user1.id,
      'university': university,
    }).select().single();
    if (productResponse != null) {
      // Upload images and update the product record with URLs
      if (_coverImage != null) {
        String? coverImageUrl = await uploadImage(_coverImage!, 'image_cover');
        if (coverImageUrl != null) {
          await saveImageUrlToDatabase(coverImageUrl, 'image_cover');
        }
      }
      if (_image1 != null) {
        String? image1Url = await uploadImage(_image1!, 'image_1');
        if (image1Url != null) {
          await saveImageUrlToDatabase(image1Url, 'image_1');
        }
      }
      if (_image2 != null) {
        String? image2Url = await uploadImage(_image2!, 'image_2');
        if (image2Url != null) {
          await saveImageUrlToDatabase(image2Url, 'image_2');
        }
      }
      if (_image3 != null) {
        String? image3Url = await uploadImage(_image3!, 'image_3');
        if (image3Url != null) {
          await saveImageUrlToDatabase(image3Url, 'image_3');
        }
      }
      floatingSnackBar(
        message: 'Product added!',
        context: context,
        textColor: Colors.green,
        textStyle: const TextStyle(color: Colors.green, fontSize: 16),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.white70,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    }
    setState(() {
      loading = false; // Stop loading after the process is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    void signOut(){
      _auth.signOut();
      Navigator.of(context).push(CustomPageRoute(child: const Welcome()));
    }
    var screenSize = MediaQuery.of(context).size;
    return loading? const Loading2():WillPopScope(
      onWillPop: () async {
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.11),
            child: const Text(
              'ADD PRODUCT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Product name input
                    Padding(
                      padding: EdgeInsets.only(top: 35, right: screenSize.width * 0.43),
                      child: const Text(
                        'Book Name - Authors',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: screenSize.width * 0.9,
                      height: 60,
                      margin: EdgeInsets.only(top: 5, right: screenSize.width * 0.03, left: screenSize.width * 0.03),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType:TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'E.g MicroBiology An Introduction 13th Edition - Gerard J.Totora ,Berdell R.Funke,Christian L.Case',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty ){
                            return 'Please enter a valid value';
                          }return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price input
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.78),
                      child: const Text(
                        'Price',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: screenSize.width * 0.9,
                      height: 60,
                      margin: EdgeInsets.only(right: screenSize.width * 0.03, left: screenSize.width * 0.03),
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty || int.tryParse(value)==null){
                            return 'Please enter a valid integer';
                          }return null;
                        },
                      ),
                    ),

                    // Quantity input
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.7),
                      child: const Text(
                        'Quantity',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: screenSize.width * 0.9,
                      height: 60,
                      margin: EdgeInsets.only(right: screenSize.width * 0.03, left: screenSize.width * 0.03),
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty || int.tryParse(value)==null){
                            return 'Please enter a valid integer';
                          }return null;
                        },
                      ),
                    ),

                    // Upload cover image and other images
                    const SizedBox(height: 35),
                    Text('First Upload cover_image then any other images inside the textbook ',style: TextStyle(fontSize: 10),),
                    _buildImageUploadButton('image_cover', screenSize),
                    _buildImageUploadButton('image_1', screenSize),
                    _buildImageUploadButton('image_2', screenSize),
                    _buildImageUploadButton('image_3', screenSize),

                    // Upload product
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: addProduct,
                        child: const Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
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

  // Image upload button widget
  Widget _buildImageUploadButton(String fieldName, Size screenSize) {
    return Column(
      children: [
        // Button to pick an image
        IconButton(
          onPressed: () => _pickImage(ImageSource.gallery, fieldName),
          icon: const Icon(Icons.add_a_photo),
        ),
        // Display the selected image with a remove button if an image is selected
        if ((fieldName == 'image_cover' && _coverImage != null) ||
            (fieldName == 'image_1' && _image1 != null) ||
            (fieldName == 'image_2' && _image2 != null) ||
            (fieldName == 'image_3' && _image3 != null))
          Stack(
            children: [
              // Display the image
              Image.file(
                fieldName == 'image_cover'
                    ? _coverImage!
                    : fieldName == 'image_1'
                    ? _image1!
                    : fieldName == 'image_2'
                    ? _image2!
                    : _image3!,
                width: screenSize.width * 0.9,
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
                      // Set the image to null to remove it
                      if (fieldName == 'image_cover') {
                        _coverImage = null;
                      } else if (fieldName == 'image_1') {
                        _image1 = null;
                      } else if (fieldName == 'image_2') {
                        _image2 = null;
                      } else if (fieldName == 'image_3') {
                        _image3 = null;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

}
