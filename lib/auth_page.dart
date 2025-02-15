import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bookjunction2_0/welcome.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          print('Auth state change: ${snapshot.connectionState}');
          print('User data: ${snapshot.data}');

          // If user is logged in
          if (snapshot.hasData && snapshot.data?.session != null) {
            final user = snapshot.data?.session?.user;

            // Simply navigate to the Welcome page without showing any dialog
            return const Welcome(); // Or conditionally return Shop/Dashboard based on user type
          } else {
            // If no user is logged in, show the Welcome page
            return const Welcome();
          }
        },
      ),
    );
  }
}
