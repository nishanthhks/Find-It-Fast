import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/student_home_page.dart';
import 'package:lost_and_found_app/utils/routs.dart';
import 'package:lost_and_found_app/services/student_authentication.dart'; // Ensure this import is correct

class StudentSignupPage extends StatefulWidget {
  const StudentSignupPage({Key? key}) : super(key: key);

  @override
  _StudentSignupPageState createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@bmsce\.ac\.in$');
  final _passwordLength = 8;

  final _nameController = TextEditingController();
  final _usnController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usnController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> studentSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res = await StudentAuthentication().studentSignUp(
        name: _nameController.text,
        usn: _usnController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (res == "User registered successfully") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StudentHomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Signup'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          "assets/images/student_image.png",
                          fit: BoxFit.contain,
                          height: 200,
                          width: 200,
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _usnController,
                          label: 'USN Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your USN number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return 'Email must end with @bmsce.ac.in';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'New Password',
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
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm New Password',
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
                        ),
                        SizedBox(height: 16.0),
                        _buildElevatedButton(
                          label: 'Sign Up',
                          onPressed: studentSignUp,
                        ),
                        SizedBox(height: 16.0),
                        _buildTextButton(
                          label: 'Already registered? Sign In',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildTextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
