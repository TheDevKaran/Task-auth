import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'UI.dart';
import 'colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  loginUser() async {
    try {
      setState(() {
        isLogin = true;
      });

      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passController.text,
          )
          .then((value) => {
                Fluttertoast.showToast(msg: "Login Succesfully!"),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  UI(),
                  ),
                ),
              });
    } catch (e) {
      setState(() {
        isLogin = false;
      });

      Fluttertoast.showToast(msg: "$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/6310507.jpg",
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome ",
                    style: TextStyle(
                        fontSize: 30,
                        color: secColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email field cant be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 4, color: secColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: mainColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: "Email",
                    hintText: "Enter Your Email",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: passController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password field cant be empty";
                    } else if (value.length < 6) {
                      return "Password must contains minimum 6 Characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 4,
                          color: secColor,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: mainColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter Your Password",
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 50,
                child: Visibility(
                  visible: isLogin,
                  child: const  CircularProgressIndicator(),
                ),
              ),
              SizedBox(
                height: 70,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: secColor,
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
