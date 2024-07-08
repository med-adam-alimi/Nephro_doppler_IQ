import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';
import 'log_in_screen.dart';
import 'doctor_page.dart';
import 'admin_page.dart';
import 'patient_page.dart';
import 'superadmin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/login': (context) => LogInScreen(),
        '/doctor': (context) => DoctorScreen(),
        '/admin': (context) => AdminScreen(),
        '/patient': (context) => PatientScreen(),
        '/superadmin': (context) => SuperAdminScreen(),
      },
    );
  }
}
