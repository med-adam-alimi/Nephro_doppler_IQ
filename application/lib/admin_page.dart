import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_page.dart'; // Add this import for patient details
import 'doctor_page.dart'; // Add this import for doctor details


class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.jpg', // Adjust the path to your image file
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Admin details button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showAdminDetailsDialog(context);
                    },
                    child: Text('View Admin Details'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Add Doctor and patient  section's
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
                      _showAddDoctorDialog(context);
                    },
                    child: Text('Add doctor'),
                  ),
                    ElevatedButton(
                    onPressed: () {
                      _showAddPatientDialog(context);
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
                      _showDeleteDoctorDialog(context);
                      // Logic to delete Doctor
                    },
                    child: Text('Delete Doctor'),
                    
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      _showDeletePatientDialog(context);
                      // Logic to delete Patient
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
                      // Logic to update information
                    },
                    child: Text('Update Roles'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Icons with Labels for Quick Access
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.blue),
                        onPressed: () {
                          // Navigate to Patient Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PatientScreen()),
                          );
                        },
                      ),
                      Text('Patient', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.orange),
                        onPressed: () {
                          // Navigate to Doctor Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DoctorScreen()),
                          );
                        },
                      ),
                      Text('Doctor', style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show dialog for adding a new Doctor
  void _showAddDoctorDialog(BuildContext context) {
    String _fullName = '';
    String _email = '';
    String _password = '';
    String _confirmPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Doctor'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onChanged: (value) => _fullName = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onChanged: (value) => _password = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    onChanged: (value) => _confirmPassword = value,
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
                // Validate and save form data
                if (_password == _confirmPassword) {
                  _addDoctorToFirestore(_fullName, _email, _password).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Doctor added successfully')),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add doctor: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to add a new Doctor to Firestore
  Future<void> _addDoctorToFirestore(String fullName, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('doctors').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'role':'doctor',
      });
    } catch (e) {
      throw e;
    }
  }

  // Function to show dialog for displaying Admin details
  void _showAdminDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Details'),
          content: Container(
            width: double.maxFinite,
            child: FutureBuilder(
              future: _fetchAdmins(),
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
                      return Text('No Admins found');
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

  // Function to fetch Admin data from Firestore
  Future<List<Map<String, dynamic>>> _fetchAdmins() async {
    List<Map<String, dynamic>> admins = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('admins').get();

      querySnapshot.docs.forEach((doc) {
        admins.add({
          'fullName': doc['fullName'],
          'email': doc['email'],
        });
      });

      return admins;
    } catch (e) {
      print('Error fetching admins: $e');
      return [];
    }
  }
}

void _showDeleteDoctorDialog(BuildContext context) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('doctors').get();
  List<QueryDocumentSnapshot> doctorDocs = snapshot.docs;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Doctor'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: doctorDocs.map((doc) {
              return ListTile(
                title: Text(doc['fullName']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    // Implement the logic to delete the doctor here
                    await FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(doc.id)
                        .delete();

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

 void _showDeletePatientDialog(BuildContext context) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('patients').get();
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
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(doc.id)
                        .delete();

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