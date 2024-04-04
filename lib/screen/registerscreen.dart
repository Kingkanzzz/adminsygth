import 'package:adminsygth/screen/loginscreen.dart';
import 'package:adminsygth/screen/user_form.dart';
import 'package:adminsygth/widgets/customButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // const RegisterScreen({super.key});
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signUp()async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_)=>UserForm()));
      }
      else{
        Fluttertoast.showToast(msg: "Something is wrong");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");

      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "The account already exists for that email.");

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
                      Text("SIGN UP",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 16),
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      // buildButtonLogIn(),
                      SizedBox(
                        height: 20
                      ),
                      // SizedBox(
                      //     width: 400,
                      //     height: 50,
                      //     child: ElevatedButton(
                      //       onPressed: () {
                      //         signUp();
                      //       },
                      //       child: Text(
                      //         "Continue",
                      //         style: TextStyle(
                      //             color: Colors.white, fontSize: 18),
                      //       ),
                      //       style: ElevatedButton.styleFrom(
                      //         primary: MainColors.maincolors,
                      //         elevation: 3,
                      //       ),
                      //     ),
                      //   ),
                      customButton("Continue", () {
                        signUp();
                      }),
                      SizedBox(height: 10),
                      Wrap(
                        children: [
                          // Text("Already have an account?",
                          // style: TextStyle(
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.w600,
                          //   color: Colors.red.shade400
                          // ),
                          // ),
                          GestureDetector(
                              child: Text(
                                "Back",
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
                                            LoginScreen()));
                              },
                            )
                        ],
                      )
                    ],
                  )),
            )));
  }
  // Container buildButtonLogIn() {
  //   return Container(
  //       constraints: BoxConstraints.expand(height: 50),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //         },
          // child: Text("Continue",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white)),
        // ),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     color: Colors.blueGrey[900]),
        // margin: EdgeInsets.only(top: 16),
        // padding: EdgeInsets.all(12)
  //       );
  // }

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
}