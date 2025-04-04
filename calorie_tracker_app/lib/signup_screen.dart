// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? email;
  String? password;
  String? repeatPassword;
  String? error;
  final _formKey = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: 'Enter your email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  maxLength: 64,
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null; // Returning null means "no issues"
                  }),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: "Enter a password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Your password must contain at least 8 characters.';
                    }
                    return null; // Returning null means "no issues"
                  }),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: "Confirm password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) => repeatPassword = value,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Your password must contain at least 8 characters.';
                    } else if (password != repeatPassword) {
                      return "Your passwords must match";
                    }
                    return null; // Returning null means "no issues"
                  }),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      trySignup();
                    }
                  }),
              const SizedBox(
                height: 12,
              ),

              // cancel button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ); // Go back to previous screen
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              ),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 12,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void trySignup() async {
    try {
      // The await keyword blocks execution to wait for
      // signInWithEmailAndPassword to complete its asynchronous execution and
      // return a result.
      //
      // FirebaseAuth will raise an exception if the email or password
      // are determined to be invalid, e.g., the email doesn't exist.
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      print("Created account ${credential.user}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Account created successfully!',
        ),
      ));
      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild

      // We need this next check to use the Navigator in an async method.
      // It basically makes sure LoginScreen is still visible.
      if (!mounted) return;

      // pop the navigation stack so people cannot "go back" to the login screen
      // after logging in.
      Navigator.of(context).pop();
      // Now go to the HomeScreen.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      // Exceptions are raised if the Firebase Auth service
      // encounters an error. We need to display these to the user.
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      // Call setState to redraw the widget, which will display
      // the updated error text.
      setState(() {});
    }
  }
}
