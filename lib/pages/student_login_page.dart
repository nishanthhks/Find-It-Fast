import 'package:flutter/material.dart';
import "package:lost_and_found_app/utils/routs.dart";

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);

  @override
  State<StudentLoginPage> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  bool _isEmailValid() {
    final email = _emailController.text.trim();
    return email.endsWith('@bmsce.ac.in');
  }

  void _submitForm() {
    if (_isEmailValid()) {
      // Add your logic for successful login here
    } else {
      setState(() {
        _errorMessage = 'Email must end with @bmsce.ac.in';
      });
    }
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                Navigator.pushNamed(context, MyRouts.studentHomePageRout);
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
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Add navigation logic for signup here
                Navigator.pushNamed(context, MyRouts.studentSignupRout);
              },
              child: const Text('Not registered? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
