import 'package:flutter/material.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 150),
            Image.asset(
              "assets/images/student_image.png",
              fit: BoxFit.contain,
              height: 250, // Adjust the height as needed
              width: 250, // Adjust the width as needed
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic here
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Add navigation logic here
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
