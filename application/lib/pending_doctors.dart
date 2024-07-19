import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PendingApprovalsScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Doctor Approvals'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('pendingUsers')
            .where('role', isEqualTo: 'Doctor')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending doctor approvals'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['fullName']),
                subtitle: Text('Email: ${doc['email']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _approveDoctor(context, doc);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        _rejectDoctor(context, doc);
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

  void _approveDoctor(BuildContext context, DocumentSnapshot doc) async {
    try {
      String uid = doc['uid'];
      
      // Move doctor from pendingUsers to the doctors collection
      await FirebaseFirestore.instance.collection('doctors').doc(uid).set(doc.data() as Map<String, dynamic>);
      await FirebaseFirestore.instance.collection('pendingUsers').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor approved and moved to doctors collection'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving doctor: $e'),
        ),
      );
    }
  }

  void _rejectDoctor(BuildContext context, DocumentSnapshot doc) async {
    try {
      String uid = doc['uid'];

      // Optionally, you can delete or move the doctor from pendingUsers
      await FirebaseFirestore.instance.collection('pendingUsers').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor rejected and removed from pending list'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting doctor: $e'),
        ),
      );
    }
  }
}
