import "package:flutter/material.dart";
import "package:lost_and_found_app/utils/routs.dart";

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
          Image.asset(
            "assets/images/search_image.png",
            fit: BoxFit.contain,
            height: 300, // Adjust the height as needed
            width: 300, // Adjust the width as needed
          ),
          const SizedBox(height: 50),
          const Text(
            "Welcome",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(height: 50),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, MyRouts.adminLoginRout);
              print("admin");
            },
            child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
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
              print("student");
            },
            child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "student",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
