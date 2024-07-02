import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/pages/admin_login_page.dart';
import 'package:lost_and_found_app/pages/student_login_page.dart';
import 'package:lost_and_found_app/pages/student_signup_page.dart';
import 'package:lost_and_found_app/pages/lost_item_details_page.dart';
import 'package:lost_and_found_app/pages/admin_home_page.dart';
import 'package:lost_and_found_app/pages/student_home_page.dart';

import "package:lost_and_found_app/utils/routs.dart";
import 'package:lost_and_found_app/providers/lost_item_form_provider.dart';

void main() {
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
          // home: AdminStudentButtonPage(),
          routes: {
            "/": (context) => AdminStudentButtonPage(),// "/" is the default route
            MyRouts.adminStudentButtonRout: (context) =>
                AdminStudentButtonPage(), 
            MyRouts.adminLoginRout: (context) => AdminLoginPage(),
            MyRouts.studentLoginRout: (context) => StudentLoginPage(),
            MyRouts.studentSignupRout: (context) => StudentSignupPage(),
            MyRouts.adminHomeRoute: (context) => AdminHomePage(),
            MyRouts.studentHomePageRout: (context) => StudentHomePage(),
            MyRouts.lostItemDetailsRout: (context) => LostItemDetailsPage(),
          }),
    );
  }
}
