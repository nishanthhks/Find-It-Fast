import 'package:flutter/material.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class AdminStudentButtonPage extends StatefulWidget {
  const AdminStudentButtonPage({Key? key});

  @override
  State<AdminStudentButtonPage> createState() => _AdminStudentButtonPage();
}

class _AdminStudentButtonPage extends State<AdminStudentButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            "LOST AND FOUND",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(height: 50),
          Image.asset(
            "assets/images/search_image.png",
            fit: BoxFit.contain,
            height: 300, // Adjust the height as needed
            width: 300, // Adjust the width as needed
          ),
          const SizedBox(height: 120),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRouts.adminLoginRout);
            },
            child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Admin",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRouts.studentLoginRout);
            },
            child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Student",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
          ),
        ],
      ),
    );
  }
}
