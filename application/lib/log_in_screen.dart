import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reset_password_screen.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Sign in the user with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Check the user's role from Firestore
        String role = await _getUserRole(userCredential.user!.uid);

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Log In Successful')),
        );

        // Navigate to the appropriate dashboard based on the user's role
        _navigateBasedOnRole(role);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.message}')),
        );
      }
    }
  }

  Future<String> _getUserRole(String uid) async {
    // Check each collection for the user and get their role
    List<String> collections = ['superadmins', 'admins', 'doctors'];
    for (String collection in collections) {
      DocumentSnapshot userDoc = await _firestore.collection(collection).doc(uid).get();
      if (userDoc.exists) {
        return userDoc['role'] as String;
      }
    }
    return 'Unknown';
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'Doctor':
        Navigator.pushReplacementNamed(context, '/doctor');
        break;
      case 'Admin':
        Navigator.pushReplacementNamed(context, '/admin');
        break;
      case 'Super Admin':
        Navigator.pushReplacementNamed(context, '/superadmin');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 98, 15, 6),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 6, 6, 157)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 244, 243, 243).withOpacity(0.5),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 6, 6, 157)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 244, 243, 243).withOpacity(0.5),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 250, // Adjust the width as needed
                    height: 60, // Adjust the height as needed
                    child: ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Log In'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
