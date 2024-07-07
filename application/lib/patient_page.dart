import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.jpg', // Adjust the path to your image file
              fit: BoxFit.cover,
            ),
          ),
          // Content overlay
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('patients').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> patients = [];
                  snapshot.data!.docs.forEach((doc) {
                    patients.add({
                      'fullName': doc['fullName'],
                      'email': doc['email'],
                      'phoneNumber': doc['phoneNumber'],
                      'age': doc['age'],
                    });
                  });

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      return _buildPatientDetails(
                        name: patients[index]['fullName'] ?? '',
                        email: patients[index]['email'] ?? '',
                        phoneNumber: patients[index]['phoneNumber'] ?? '',
                        age: patients[index]['age']?.toString() ?? '',
                        iconColor: Colors.green,
                        onImportMediaPressed: () {
                          _importMedia(context, patients[index]['fullName'] ?? '');
                        },
                      );
                    },
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetails({
    required String name,
    required String email,
    required String phoneNumber,
    required String age,
    required Color iconColor,
    required VoidCallback onImportMediaPressed,
  }) {
    return Card(
      color: Colors.white70,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.account_circle, color: iconColor),
              title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: $email', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Phone: $phoneNumber', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Age: $age', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: onImportMediaPressed,
                  tooltip: 'Import Photo',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _importMedia(BuildContext context, String patientName) {
    // Replace this with actual logic to import media (photo/video) for the patient
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Importing media for $patientName'),
    ));
  }
}
