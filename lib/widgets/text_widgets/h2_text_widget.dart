import 'package:flutter/material.dart';

class H2TextWidget extends StatelessWidget {
  final String message;
  const H2TextWidget({required this.message,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
  message ,style: const TextStyle(fontSize: 20,color: Colors.black,)
    );
  }
}