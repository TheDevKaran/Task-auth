import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinishPage extends StatelessWidget {
  final Map<String, dynamic> submittedData;

  const FinishPage({Key? key, required this.submittedData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Submitted'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get()
            .then((value) => value.docs.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${data['Name']}'),
                Text('Email: ${data['Email']}'),
                SizedBox(height: 20),
                Image.network(data['Screenshot']),
              ],
            ),
          );
        },
      ),
    );
  }
}
