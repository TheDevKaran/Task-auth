import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const FinishPage({Key? key, required this.userName, required this.userEmail}) : super(key: key);

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  loadImage() async{
    //current user id
    final _userID = FirebaseAuth.instance.currentUser!.uid;

    //collect the image name
    DocumentSnapshot variable = await FirebaseFirestore.instance.
    collection('data_user').
    doc('user').
    collection('personal_data').
    doc(_userID).
    get();

    //a list of images names (i need only one)
    var _file_name = variable['path_profile_image'];

    //select the image url
    Reference  ref = FirebaseStorage.instance.ref().child("images/user/profile_images/${_userID}").child(_file_name[0]);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url: url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/2.jpg',
                width: 200.0,
                height: 200.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Welcome ${widget.userName}!", // Display the user's name here
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your email is ${widget.userEmail}',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 16.0),
            ),
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/tick.png',
                width: 200.0,
                height: 200.0,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child:  Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
