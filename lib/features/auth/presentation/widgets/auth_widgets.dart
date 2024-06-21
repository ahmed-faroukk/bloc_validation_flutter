import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildRoundedButton({required String text, required VoidCallback? onClick}) {
  return SizedBox(
    width: double.infinity, // Make the button match the width of its parent
    child: ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Set the button's background color to black
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white), // Set the text color to white for contrast
      ),
    ),
  );
}



