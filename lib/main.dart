import 'package:bookjunction2_0/Buyer/confirmation.dart';
import 'package:bookjunction2_0/Buyer/shop.dart';
import 'package:bookjunction2_0/auth_page.dart';
import 'package:bookjunction2_0/model/store.dart';
import 'package:bookjunction2_0/repository/authentication_repository/authentication_repo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Buyer/Bsetting.dart';


void main() async {
  //WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is ready to initialize services.

  // Initialize Firebase and Supabase
  await Supabase.initialize(
    url:"https://rvvuqurtayxwnogntcjo.supabase.co" ,
    anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2dnVxdXJ0YXl4d25vZ250Y2pvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyMjg0ODMsImV4cCI6MjA0OTgwNDQ4M30.pHUNROJi_J4j7Y8fkUFxB00c_nSAi0xPYAmGpwJ3-uA" ,
  );



  // Dependency injection using Get.put
  Get.put(AuthenticationRepository());


  // Run the app
  runApp(
    ChangeNotifierProvider(
      create: (context) => Store(),
      child: const MyApp(), // Ensure MyApp is passed as the child
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Signup Form',
      debugShowCheckedModeBanner: false,
      home:AuthPage(),
    );
  }
}