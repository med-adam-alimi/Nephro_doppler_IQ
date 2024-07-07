
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_page.dart'; // Import the patient_page.dart file

class DoctorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
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
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Doctor details button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showDoctorDetailsDialog(context);
                    },
                    child: Text('View Doctor Details'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Add Roles section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Roles:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showAddPatientDialog(context); // Call function to show add patient dialog
                    },
                    child: Text('Add Patient'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Delete Roles section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Roles:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showDeletePatientDialog(context);
                    },
                    child: Text('Delete Patient'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Update Information section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Information:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showUpdatePatientDialog(context);
                    },
                    child: Text('Update Roles'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Icons with Labels for Quick Access
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientScreen()),
                      );
                    },
                  ),
                  Text('Patient', style: TextStyle(color: Colors.blue)),
                ],
              ),
              SizedBox(height: 60), // Move the Patient icon lower
            ],
          ),
        ],
      ),
    );
  }

  // Function to show dialog for displaying Doctor details
  void _showDoctorDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doctor Details'),
          content: Container(
            width: double.maxFinite,
            child: FutureBuilder(
              future: _fetchDoctors(),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error fetching data: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data![index]['fullName']),
                            subtitle: Text(snapshot.data![index]['email']),
                          );
                        },
                      );
                    } else {
                      return Text('No Doctors found');
                    }
                  }
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for adding a new Patient
  void _showAddPatientDialog(BuildContext context) {
    String _fullName = '';
    String _email = '';
    String _phoneNumber = '';
    int _age = 0;

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Patient'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onChanged: (value) => _fullName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => _phoneNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _age = int.parse(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addPatientToFirestore(_fullName, _email, _phoneNumber, _age).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patient added successfully')),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add patient: $error')),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for updating Patient details
  void _showUpdatePatientDialog(BuildContext context) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('patients').get();
    List<QueryDocumentSnapshot> patientDocs = snapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Patient Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: patientDocs.map((doc) {
                return ListTile(
                  title: Text(doc['fullName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${doc['email']}'),
                      Text('Phone: ${doc['phoneNumber']}'),
                      Text('Age: ${doc['age']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditPatientDialog(context, doc);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for editing a Patient's details
  void _showEditPatientDialog(BuildContext context, QueryDocumentSnapshot doc) {
    String _fullName = doc['fullName'];
    String _email = doc['email'];
    String _phoneNumber = doc['phoneNumber'];
    int _age = doc['age'];

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Patient Details'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: _fullName,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onChanged: (value) => _fullName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: _phoneNumber,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => _phoneNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: _age.toString(),
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _age = int.parse(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updatePatientInFirestore(doc.id, _fullName, _email, _phoneNumber, _age).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patient updated successfully')),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update patient: $error')),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to add a new Patient to Firestore
  Future<void> _addPatientToFirestore(String fullName, String email, String phoneNumber, int age) async {
    try {
      await FirebaseFirestore.instance.collection('patients').add({
        'fullName': fullName,
        'age': age,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': 'Patient', // Setting role as Patient
      });
    } catch (e) {
      throw e;
    }
  }

  // Function to update a Patient's details in Firestore
  Future<void> _updatePatientInFirestore(String docId, String fullName, String email, String phoneNumber, int age) async {
    try {
      await FirebaseFirestore.instance.collection('patients').doc(docId).update({
        'fullName': fullName,
        'age': age,
        'email': email,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw e;
    }
  }

  // Function to fetch Doctor data from Firestore
  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    List<Map<String, dynamic>> doctors = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('doctors').get();

      querySnapshot.docs.forEach((doc) {
        doctors.add({
          'fullName': doc['fullName'],
          'email': doc['email'],
          'role': 'doctor',
        });
      });

      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }

  // Function to show dialog for deleting a Patient
  void _showDeletePatientDialog(BuildContext context) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('patients').get();
    List<QueryDocumentSnapshot> patientDocs = snapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Patient'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: patientDocs.map((doc) {
                return ListTile(
                  title: Text(doc['fullName']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Implement the logic to delete the patient here
                      await FirebaseFirestore.instance.collection('patients').doc(doc.id).delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${doc['fullName']} deleted')),
                      );

                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

