import 'package:flutter/material.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class AdminStudentButtonPage extends StatefulWidget {
  const AdminStudentButtonPage({Key? key}) : super(key: key);

  @override
  State<AdminStudentButtonPage> createState() => _AdminStudentButtonPage();
}

class _AdminStudentButtonPage extends State<AdminStudentButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOST AND FOUND",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50),
            Image.asset(
              "assets/images/search_image.png",
              fit: BoxFit.contain,
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 50),
            _buildNavigationButton(
              label: "Admin",
              onPressed: () {
                Navigator.pushNamed(context, MyRouts.adminLoginRout);
              },
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              label: "Student",
              onPressed: () {
                Navigator.pushNamed(context, MyRouts.studentLoginRout);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
