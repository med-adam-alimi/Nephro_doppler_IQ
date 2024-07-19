import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PendingApprovalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Approvals'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('pendingUsers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending approvals'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['fullName']),
                subtitle: Text('Role: ${doc['role']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _approveUser(context, doc);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        _rejectUser(context, doc);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _approveUser(BuildContext context, DocumentSnapshot doc) async {
    try {
      String role = doc['role'];
      String uid = doc['uid'];
      String collection;
      switch (role) {
        case 'Doctor':
          collection = 'doctors';
          break;
        case 'Admin':
          collection = 'admins';
          break;
        case 'Super Admin':
          collection = 'superadmins';
          break;
        default:
          collection = 'users'; // Fallback, not recommended
      }

      // Move user from pendingUsers to the specific collection
      await FirebaseFirestore.instance.collection(collection).doc(uid).set(doc.data() as Map<String, dynamic>);
      await FirebaseFirestore.instance.collection('pendingUsers').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User approved and moved to $collection'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving user: $e'),
        ),
      );
    }
  }

  void _rejectUser(BuildContext context, DocumentSnapshot doc) async {
    try {
      String uid = doc['uid'];

      // Remove user from pendingUsers
      await FirebaseFirestore.instance.collection('pendingUsers').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User rejected and removed from pending list'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting user: $e'),
        ),
      );
    }
  }
}
