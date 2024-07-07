import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'log_in_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Registration',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nephro_doppler',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 87, 2, 10),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 280,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Log In'),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text('Sign In'),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  '@Nephro_Doppler all rights reserved',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 7, 7, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
