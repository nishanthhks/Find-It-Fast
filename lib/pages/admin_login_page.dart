import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/admin_home_page.dart';
import 'package:lost_and_found_app/services/admin_authentication.dart'; // Import your admin authentication service

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void adminSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res = await AdminAuthentication().adminSignIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (res == "Sign in successful") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminHomePage()));
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
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginTitle(),
                const SizedBox(height: 20),
                const LoginImage(),
                const SizedBox(height: 30),
                EmailFormField(controller: _emailController),
                const SizedBox(height: 20),
                PasswordFormField(controller: _passwordController),
                const SizedBox(height: 20),
                isLoading ? const CircularProgressIndicator() : LoginButton(onPressed: adminSignIn),
                const SizedBox(height: 10),
                ForgotPasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Admin Login',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/admin_image.png",
      fit: BoxFit.contain,
      height: 250,
      width: 250,
    );
  }
}

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;

  const EmailFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final _emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@bmsce\.ac\.in$');

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
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
    );
  }
}

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final _passwordLength = 8;

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
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
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: const Text('Log in'),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        dialogBox(context);
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

void dialogBox(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final auth = AdminAuthentication();

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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogTitle(),
              const SizedBox(height: 20),
              const DialogDescription(),
              const SizedBox(height: 20),
              DialogEmailField(controller: _emailController),
              const SizedBox(height: 20),
              DialogActions(emailController: _emailController, auth: auth),
            ],
          ),
        ),
      );
    },
  );
}

class DialogTitle extends StatelessWidget {
  const DialogTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Forgot Password',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DialogDescription extends StatelessWidget {
  const DialogDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Enter your email to reset your password',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class DialogEmailField extends StatelessWidget {
  final TextEditingController controller;

  const DialogEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

class DialogActions extends StatelessWidget {
  final TextEditingController emailController;
  final AdminAuthentication auth;

  const DialogActions({
    super.key,
    required this.emailController,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DialogActionButton(
          label: 'Close',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 10),
        DialogActionButton(
          label: 'Submit',
          onPressed: () async {
            final email = emailController.text.trim();
            try {
              await auth.sendPasswordResetEmail(email: email);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password reset email sent to $email')),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error sending password reset email'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class DialogActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DialogActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
