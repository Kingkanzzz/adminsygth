import 'package:adminsygth/homepage/homepage.dart';
import 'package:adminsygth/screen/registerscreen.dart';
import 'package:adminsygth/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';


class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, 
              password: _passwordController.text);
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => HomePage()));
      } else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            // color: Colors.lightGreenAccent[200],
            color: Colors.blue[900],
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(colors: [
                        Colors.cyan.shade200,
                        Colors.blue.shade200
                      ])),
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("LOG IN",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 16),
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      // buildButtonLogIn(),
                      SizedBox(
                        height: 10
                      ),
                      customButton("LOG IN", () {
                        signIn();
                      }),
                      SizedBox(height: 20),
                      Wrap(
                        children: [
                          Text("Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red
                          ),
                          ),
                          GestureDetector(
                              child: Text(
                                " Sign Up",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[900],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                            )
                        ],
                      )
                    ],
                  )),
            )));
  }

  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
          controller: _emailController,
            decoration: InputDecoration(
              hintText: "test@gmail.com",
              hintStyle: TextStyle(fontSize: 12),
              labelText: "EMAIL",
              labelStyle: TextStyle(
                fontSize: 16, 
                color: Colors.black
              ),
              ),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldPassword() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: "password must be 6 character",
          hintStyle: TextStyle(fontSize: 12),
          labelText: 'PASSWORD',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          suffixIcon: _obscureText == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = false;
                    });
                  },
                  icon: Icon(Icons.remove_red_eye, size: 20))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = true;
                    });
                  },
                  icon: Icon(
                    Icons.visibility_off,
                    size: 20,
                  )),
        ),
      ),
    );
  }
  // signIn(){
  //   _auth.signInWithEmailAndPassword(
  //       email: "test@gmail.com",
  //       password: "test123"
  //   ).then((user) {
  //     print("signed in ${user.email}");
  //   }).catchError((error) {
  //      print(error);
  //   });
  // }
}
