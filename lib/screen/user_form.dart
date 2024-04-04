import 'package:adminsygth/homepage/homepage.dart';
import 'package:adminsygth/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
 
  sendUserDataToDB()async{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser!.email).set({
      "fullname":_fullnameController.text,
      "lastname": _lastnameController.text,
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()))).catchError((error)=>print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style:
                      TextStyle(fontSize: 22.sp, color: Colors.blue[900]),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'fullname',
                  ),
                  controller: _fullnameController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'lastname',
                  ),
                  controller: _lastnameController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  ],
                ),
                // myTextField("enter your fullname",TextInputType.text,_fullnameController),
                // myTextField("enter your lastname",TextInputType.text,_lastnameController),
                // myTextField("enter your phone number",TextInputType.number,_phoneController),
                // TextField(
                //   controller: _dobController,
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     hintText: "date of birth",
                //     suffixIcon: IconButton(
                //       onPressed: () => _selectDateFromPicker(context),
                //       icon: Icon(Icons.calendar_today_outlined),
                //     ),
                //   ),
                // ),
                // TextField(
                //   controller: _genderController,
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     hintText: "choose your gender",
                //     prefixIcon: DropdownButton<String>(
                //       items: gender.map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: new Text(value),
                //           onTap: () {
                //             setState(() {
                //               _genderController.text = value;
                //             });
                //           },
                //         );
                //       }).toList(),
                //       onChanged: (_) {},
                //     ),
                //   ),
                // ),
                // myTextField("enter your age",TextInputType.number,_ageController),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
               customButton("Submit",()=>sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

