import 'package:flutter/material.dart';

Widget customButton (String buttonText,onPressed){
  return SizedBox(
    width: 400,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[900],
        elevation: 3,
      ),
    ),
  );
}