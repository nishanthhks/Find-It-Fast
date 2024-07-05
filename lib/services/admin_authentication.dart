// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthentication {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String> adminSignIn({
  required String email,
  required String password,
}) async {
  String response = 'Some error occurred';
  bool isAdmin = false;
  
  try {
    
    // Authenticate with Firebase Auth
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Check if the user is an admin
    isAdmin = await isAdminUser(email);
    
    if (!isAdmin) {
      throw FirebaseAuthException(
        code: 'invalid-credentials',
        message: 'Invalid admin credentials',
      );
    }

    response = "Sign in successful";
  } on FirebaseAuthException catch (e) {
    print("FirebaseAuthException: ${e.message}");
    response = e.message ?? 'An error occurred';
  } catch (e) {
    print("Exception: ${e.toString()}");
    response = 'An unknown error occurred';
  }

  return response;
}


  Future<bool> isAdminUser(String email) async {
    // Check if the email matches an admin email in Firestore
        print("-------------------${email}--------in auth---");

    DocumentSnapshot adminDoc =
        await _firestore.collection('admins').doc('credentials').get();
    String adminEmail = adminDoc['email'];
    print("Admin email: $adminEmail");
    return email == adminEmail;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
