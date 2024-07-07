import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/pages/admin_login_page.dart';
import 'package:lost_and_found_app/pages/student_login_page.dart';
import 'package:lost_and_found_app/pages/student_signup_page.dart';
import 'package:lost_and_found_app/pages/lost_item_details_page.dart';
import 'package:lost_and_found_app/pages/admin_home_page.dart';
import 'package:lost_and_found_app/pages/student_home_page.dart';
import 'package:lost_and_found_app/pages/lost_item_bin_catalog.dart';
import 'package:lost_and_found_app/pages/student_profile_page.dart';

import "package:lost_and_found_app/utils/routs.dart";
import 'package:lost_and_found_app/providers/lost_item_form_provider.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lost_and_found_app/dataStore/details_store_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LostItemFormProvider()),
      ],
      child: MaterialApp(
        title: 'Lost and Found',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StudentHomePage(),
        // home: _buildAuthStateWidget(),
        routes: {
          MyRouts.adminStudentButtonRout: (context) => AdminStudentButtonPage(),
          MyRouts.adminLoginRout: (context) => AdminLoginPage(),
          MyRouts.studentLoginRout: (context) => StudentLoginPage(),
          MyRouts.studentSignupRout: (context) => StudentSignupPage(),
          MyRouts.studentProfileRout: (context) => StudentProfilePage(),
          MyRouts.adminHomeRoute: (context) => AdminHomePage(),
          MyRouts.studentHomeRout: (context) => StudentHomePage(),
          MyRouts.lostItemDetailsRout: (context) => LostItemDetailsPage(),
          MyRouts.lostItemBinCatalogRout: (context) => LostItemBinCatalog(),
        },
      ),
    );
  }

  Future<bool> isAdminUser(User? user) async {
    if (user == null) return false;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('admins')
          .doc("credentials")
          .get();
      
      // Assuming there's a 'role' field in the document indicating admin or student
      String? role = doc['role'];
      
      // Return true if role is 'admin', false otherwise
      return role == 'admin';
    } catch (e) {
      print('Error determining user role: $e');
      return false; // Default to false on error
    }
  }

  Widget _buildAuthStateWidget() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          // Check the logged-in user's role to determine navigation
          User? user = snapshot.data;
          return FutureBuilder<bool>(
            future: isAdminUser(user),
            builder: (context, isAdminSnapshot) {
              if (isAdminSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (isAdminSnapshot.hasData) {
                bool isAdmin = isAdminSnapshot.data!;
                if (isAdmin) {
                  return AdminHomePage(); // Navigate to AdminHomePage
                } else {
                  return StudentHomePage(); // Navigate to StudentHomePage
                }
              } else {
                return const Text('Error determining user role');
              }
            },
          );
        }
        return AdminStudentButtonPage(); // Show login buttons if no user is logged in
      },
    );
  }
}
