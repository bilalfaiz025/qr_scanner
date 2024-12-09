import 'package:flutter/material.dart';

class H1TextWidget extends StatelessWidget {
  final Color? txtcolor;
  final String message;
  const H1TextWidget({required this.message,this.txtcolor,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
  message ,style:  TextStyle(fontSize: 35,color: txtcolor??Colors.black,fontWeight:FontWeight.bold ),
    );
  }
}