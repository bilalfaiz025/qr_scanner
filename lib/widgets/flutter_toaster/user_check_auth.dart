import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebasesOperations {
  void toastmessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(225, 226, 236, 185),
      textColor: Colors.black,
      fontSize: 15,
    );
  }
}
