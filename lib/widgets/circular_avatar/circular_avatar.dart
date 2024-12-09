import 'package:flutter/material.dart';

class CircularAvWidget extends StatelessWidget {
  final String url;
  const CircularAvWidget({required this.url,super.key});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(url),
    );
  }
}
