import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/pages/admin_login_page.dart';
import 'package:lost_and_found_app/pages/student_login_page.dart';
import 'package:lost_and_found_app/pages/lost_item_details.dart';
import "package:lost_and_found_app/utils/routs.dart";
import 'package:lost_and_found_app/providers/lost_item_form_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(routes: {
  //     "/": (context) => LostItemDetails(), // "/" is the default route
  //     MyRouts.studentLoginRout: (context) => StudentLogin(),
  //     MyRouts.adminLoginRout: (context) => AdminLoginPage(),
  //     MyRouts.lostItemDetailsRout: (context) => LostItemDetails(),
  //     MyRouts.adminStudentButtonRout: (context) => AdminStudentButtonPage(),
  //   });
  // }
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
            "/": (context) =>
                AdminLoginPage(), // "/" is the default route
            MyRouts.studentLoginRout: (context) => StudentLogin(),
            MyRouts.adminLoginRout: (context) => AdminLoginPage(),
            MyRouts.lostItemDetailsRout: (context) => LostItemDetails(),
            MyRouts.adminStudentButtonRout: (context) =>
                AdminStudentButtonPage(),
          }),
    );
  }
}
