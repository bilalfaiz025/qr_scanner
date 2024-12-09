import 'package:flutter/material.dart';

class H3TextWidget extends StatelessWidget {
  final Color? txtcolor;
  final String message;
  final TextDecoration? txtdecor;
  final FontWeight? txtweight;
  const H3TextWidget({required this.message,this.txtcolor, this.txtweight,this.txtdecor,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
  message ,style:  TextStyle(fontSize: 15,color: txtcolor??Colors.black.withOpacity(0.7),
  decorationThickness: -2,decoration:txtdecor,fontWeight: txtweight ),
    );
  }
}