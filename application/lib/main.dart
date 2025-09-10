
import 'package:flutter/foundation.dart' show kIsWeb;
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
  if (kIsWeb) {
    // Web-specific Firebase initialization
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA_ZPlaJMbICApv1V59Rpls9uKcq2NVsxw",
        authDomain: "nephrollogy-doppler.firebaseapp.com",
        projectId: "nephrollogy-doppler",
        storageBucket: "nephrollogy-doppler.appspot.com",
        messagingSenderId: "186807755847",
        appId: "1:186807755847:web:eaa7d648a36124d3c97d62",
        measurementId: "G-WXJFRKDVJ7",
      ),
    );
  } else {
    // Mobile-specific Firebase initialization
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nephro_doppler',
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

