import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:feedback_abhyaz/Finish.dart';
import 'package:feedback_abhyaz/signup_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

TextEditingController feedbackController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController yournameController = TextEditingController();
TextEditingController emailidController = TextEditingController();
TextEditingController deptController = TextEditingController();
TextEditingController durationController = TextEditingController();

class UI extends StatefulWidget {
  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  Future<String> uploadImageToFirebase() async {
    if (_selectedImage != null) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('feedback_images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);
        await uploadTask.whenComplete(() => null);
        String imageURL = await storageReference.getDownloadURL();
        return imageURL;
      } catch (error) {
        print("Error uploading image: $error");
        return "";
      }
    } else {
      return "";
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  List<bool> isTypeSelected = [false, false, false, false, false];
  User? userid = FirebaseAuth.instance.currentUser;
  double userRating1 = 0.0;
  double userRating2 = 0.0;
  double userRating3 = 0.0;
  double userRating4 = 0.0;
  double userRating5 = 0.0;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // TextEditingController feedbackController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 2.0,
          centerTitle: true,
          title: Text(
            "Enter Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {},
          // ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 50),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                title: const Text("Signout"),
                trailing: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: Stack(children: [
          // Background Image

          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Image.asset('assets/images/feed.jpg',height: 100,),
                buildFeedbackForm(),

                Center(
                    child: Text(
                  "Please fill out this form",
                  style: TextStyle(color: Colors.blue.shade800, fontSize: 20),
                )),
                SizedBox(
                  height: 17,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Name", style: TextStyle(fontSize: 20)),
                        SizedBox(
                          width: 90,
                        ),
                        Expanded(
                          child: TextField(
                            controller: yournameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFFC5C5C5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Email", style: TextStyle(fontSize: 20)),
                        SizedBox(
                          width: 93,
                        ),
                        Expanded(
                          child: TextField(
                            controller: emailidController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFFC5C5C5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isSubmitting = true;
                        });
                        print(feedbackController.text);
                        bool _formisvalid = _formKey.currentState!.validate();
                        if (!!_formisvalid) {
                          String message;
                          List<String> selectedCheckItems = [];
                          for (int i = 0; i < isTypeSelected.length; i++) {
                            if (isTypeSelected[i]) {
                              // Assuming you have a list of check items
                              List<String> checkItems = [
                                "Login trouble",
                                "Phone number related",
                                "Personal profile",
                                "Other issues",
                                "Suggestions",
                              ];
                              selectedCheckItems.add(checkItems[i]);
                            }
                          }
                          try {
                            final collection = FirebaseFirestore.instance
                                .collection('feedback');
                            String imageURL = await uploadImageToFirebase();
                            await collection.add({
                              'timestamp': FieldValue.serverTimestamp(),
                              'Name': yournameController.text,
                              'Email': emailidController.text,
                              'Department': deptController.text,
                              'Duration': durationController.text,
                              'Phone Number': phoneController.text,
                              'Experience': userRating1,
                              'Expectations': userRating2,
                              'Relevant': userRating3,
                              'Culture': userRating4,
                              'Recommend': userRating5,
                              'Feedback': feedbackController.text,
                              'Screenshot': imageURL,
                              'Type of Feedback': selectedCheckItems,
                            });
                            message = "Feedback Submitted";
                          } catch (_) {
                            message = "Oops, Something wrong";
                          }
                          setState(() {
                            isSubmitting = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors
                                  .green, // Set your desired background color
                              behavior: SnackBarBehavior
                                  .fixed, // This will make the SnackBar appear at the top
                            ),
                          );

                          // Navigator.pop(context);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinishPage(
                                userName: yournameController
                                    .text, userEmail: emailidController.text,), // Replace "John" with the actual user's name
                          ),
                        );
                      },
                      child: isSubmitting
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              "SUBMIT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade800)),
                    )
                  ],
                )
              ],
            ),
          ),
        ]));
  }

  buildFeedbackForm() {
    // TextEditingController feedbackController = TextEditingController();

    return Container(
      height: 200,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                      color: Color(0xFFA6A6A6),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.blue.shade800, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _selectedImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 70.0, // Set your desired radius
                          backgroundColor: Color(0xFFE5E5E5),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? Icon(
                                  Icons.add,
                                  color: Color(0xFFA5A5A5),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          // if (_selectedImage != null)
          //   Positioned(
          //     bottom: 10.0,
          //     right: 10.0,
          //     child: Image.file(
          //       _selectedImage!,
          //       width: 50.0,
          //       height: 50.0,
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget buildCheckItem({required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }
}
