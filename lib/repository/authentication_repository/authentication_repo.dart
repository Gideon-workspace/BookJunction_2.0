import 'package:supabase_flutter/supabase_flutter.dart';

import '../exceptions/signup_failure.dart';

class AuthenticationRepository {
  final _supabase = Supabase.instance.client;

  /// Create a new user in Supabase (Sign-Up)
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);

      if (response.user != null) {
        print("User created successfully: ${response.user?.email}");
        return response.user;
      } else {
        throw SignUpWithEmailAndPasswordFailure("User creation failed.");
      }
    } on AuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.statusCode ?? 'unknown');
      print("AuthException during user creation: ${ex.message}");
      throw ex;
    } catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print("Exception during user creation: ${ex.message}");
      throw ex;
    }
  }

  /// Authenticate an existing user in Supabase (Log-In)
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user != null) {
        print("User logged in successfully: ${response.user?.email}");
        return response.user;
      } else {
        throw SignUpWithEmailAndPasswordFailure("Login failed.");
      }
    } on AuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.statusCode ?? 'unknown');
      print("AuthException during login: ${ex.message}");
      throw ex;
    } catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print("Exception during login: ${ex.message}");
      throw ex;
    }
  }

  /// Send an email verification link


  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error during sign out: ${e.toString()}");
    }
  }
}
