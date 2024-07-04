import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/student_home_page.dart';
import 'package:lost_and_found_app/services/authentication.dart';
import 'package:lost_and_found_app/utils/routs.dart';

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

      String res = await AuthServices().studentSignIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

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
      body: SingleChildScrollView(
        child: Container(
          height:
              MediaQuery.of(context).size.height, // Ensure full screen height
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                ElevatedButton(
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
                    // Add navigation logic here
                  },
                  child: Text('Forgot Password?'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Add navigation logic for signup here
                    Navigator.pushNamed(context, MyRouts.studentSignupRout);
                  },
                  child: Text('Not registered? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
