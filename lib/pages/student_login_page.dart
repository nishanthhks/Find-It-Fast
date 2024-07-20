import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/student_home_page.dart';
import 'package:lost_and_found_app/utils/routs.dart';
import 'package:lost_and_found_app/services/student_authentication.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);

  @override
  State<StudentLoginPage> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@bmsce\.ac\.in$');
  final _passwordLength = 8;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void studentSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res = await StudentAuthentication().studentSignIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        isLoading = false;
      });

      if (res == "Sign in successful") {
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Ensure full screen height
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40), // Space above the "Student Login" text
                Text(
                  'Student Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/student_image.png",
                  fit: BoxFit.contain,
                  height: 250, // Adjust the height as needed
                  width: 250, // Adjust the width as needed
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
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
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < _passwordLength) {
                      return 'Password must be at least $_passwordLength characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator() // Show a loading indicator if isLoading is true
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      studentSignIn();
                    }
                  },
                  child: Text('Log in'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    dialogBox(context);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRouts.studentSignupRout);
                  },
                  child: Text(
                    'Not registered? Sign up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void dialogBox(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final auth = StudentAuthentication();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      try {
                        await auth.sendPasswordResetEmail(email: email);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Password reset email sent to $email'),
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error sending password reset email'),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
