import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/pages/admin_login_page.dart';
import 'package:lost_and_found_app/pages/student_login_page.dart';
import "package:lost_and_found_app/utils/routs.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      "/": (context) => AdminStudentButtonPage(), // "/" is the default route
      MyRouts.studentLoginRout: (context) => StudentLogin(),
      MyRouts.adminLoginRout: (context) => AdminLoginPage(),
    });
  }
}
