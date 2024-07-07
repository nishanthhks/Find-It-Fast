import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentAuthentication {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Student sign up
  Future<String> studentSignUp({
    required String name,
    required String usn,
    required String email,
    required String password,
  }) async {
    String response = 'Some error occurred';
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('students')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'usn': usn,
        'email': email,
        'uid': userCredential.user!.uid,
        "role": "student",
      });

      response = "User registered successfully";
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      response = e.message ?? 'An error occurred';
    } catch (e) {
      print("Exception: ${e.toString()}");
      response = 'An unknown error occurred';
    }

    return response;
  }

  // Student sign in
  Future<String> studentSignIn({
    required String email,
    required String password,
  }) async {
    String response = 'Some error occurred';
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
