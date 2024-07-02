import 'package:flutter/material.dart';
import "package:lost_and_found_app/utils/routs.dart";

class StudentSignupPage extends StatefulWidget {
  const StudentSignupPage({Key? key}) : super(key: key);
  @override
  _StudentSignupPageState createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@bmsce\.ac\.in$');
  final _passwordLength = 8;

  String _name = '';
  String _usn = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Signup'),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/student_image.png",
                  fit: BoxFit.contain,
                  height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'USN Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your USN number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _usn = value ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'Email must end with @bmsce.ac.in';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value ?? '';
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < _passwordLength) {
                      return 'Password must have at least $_passwordLength characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value ?? '';
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmPassword = value ?? '';
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Perform signup logic here
                      Navigator.pushNamed(context, MyRouts.studentHomePageRout);
                    }
                  },
                ),
                TextButton(
                  child: Text('Already registered? Sign In'),
                  onPressed: () {
                    // Navigate to signin page
                    Navigator.pushNamed(context, MyRouts.studentLoginRout);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
