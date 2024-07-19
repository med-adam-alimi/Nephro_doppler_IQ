
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:Nephro_doppler/google_drive_service.dart'; // Adjust the path accordingly
import 'dart:io';

class PatientScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.jpg', // Adjust the path to your image file
              fit: BoxFit.cover,
            ),
          ),
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
                      'id': doc.id,
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
                        context: context,
                        patientId: patients[index]['id'],
                        name: patients[index]['fullName'] ?? '',
                        email: patients[index]['email'] ?? '',
                        phoneNumber: patients[index]['phoneNumber'] ?? '',
                        age: patients[index]['age']?.toString() ?? '',
                        iconColor: Colors.green,
                        onImportMediaPressed: () {
                          _importMedia(context, patients[index]['fullName'] ?? '', patients[index]['email'] ?? '', patients[index]['id']);
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
    required BuildContext context,
    required String patientId,
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
                  tooltip: 'Import Photo/Video',
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildPhotosList(context, patientId),
          ],
        ),
      ),
    );
  }

  Future<void> _importMedia(BuildContext context, String patientName, String userEmail, String patientId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must be signed in to upload media'),
      ));
      return;
    }

    final MediaSource? mediaSource = await _getMediaSource(context);

    if (mediaSource == null) {
      return;
    }

    XFile? media;
    if (mediaSource == MediaSource.image) {
      media = await _picker.pickImage(source: ImageSource.gallery);
    } else if (mediaSource == MediaSource.video) {
      media = await _picker.pickVideo(source: ImageSource.gallery);
    }

    if (media != null) {
      try {
        String? description = await _getDescription(context);

        if (description == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Description is required'),
          ));
          return;
        }

        final driveApi = await getDriveApi();
        if (driveApi == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to get Google Drive API'),
          ));
          return;
        }

        final drive.File fileMetadata = drive.File();
        fileMetadata.name = '${DateTime.now().millisecondsSinceEpoch}.${mediaSource == MediaSource.image ? 'jpg' : 'mp4'}';
        fileMetadata.parents = ['1fCdqX7eFrpYmRYiVYjudYFh3F2i_iCkr']; // Replace with your folder ID

        final Stream<List<int>> mediaStream = media.openRead();
        final int mediaLength = await media.length();
        final drive.Media mediaUpload = drive.Media(mediaStream, mediaLength);


        final drive.File uploadedFile = await driveApi.files.create(
          fileMetadata,
          uploadMedia: mediaUpload,
        );

        final String fileId = uploadedFile.id!;

        await FirebaseFirestore.instance.collection('patients').doc(patientId).collection('photos').add({
          'fileId': fileId,
          'description': description,
          'type': mediaSource == MediaSource.image ? 'image' : 'video',
          'uploadedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Media uploaded successfully'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload media: $e'),
        ));
      }
    }
  }

  Future<MediaSource?> _getMediaSource(BuildContext context) async {
    return showDialog<MediaSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Media Type'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, MediaSource.image),
            child: Text('Photo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, MediaSource.video),
            child: Text('Video'),
          ),
        ],
      ),
    );
  }

  Future<String?> _getDescription(BuildContext context) async {
    TextEditingController descriptionController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Description'),
        content: TextField(
          controller: descriptionController,
          decoration: InputDecoration(hintText: 'Description'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, descriptionController.text),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosList(BuildContext context, String patientId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('patients').doc(patientId).collection('photos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final photos = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final String fileId = photo['fileId'];
            final String description = photo['description'];
            final String type = photo['type'];

            return ListTile(
              title: Text(description),
              subtitle: Text(type),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  final driveApi = await getDriveApi();
                  if (driveApi != null) {
                    await driveApi.files.delete(fileId);
                  }

                  await FirebaseFirestore.instance.collection('patients').doc(patientId).collection('photos').doc(photo.id).delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

enum MediaSource {
  image,
  video,
}
