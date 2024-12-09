import 'package:flutter/material.dart';
class Roundbutton extends StatelessWidget {
  final String title;
  final bool loading;
  final void Function()? ontap;

  const Roundbutton({Key? key,required this.title,this.ontap,this.loading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        width: 330,
        decoration: BoxDecoration(
          color:  const Color.fromARGB(225, 226, 236, 185),
          borderRadius: BorderRadius.circular(18),

        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Color.fromARGB(255, 8, 8, 8),) :
          Text(title,style: const TextStyle(letterSpacing:1,color: Colors.black,fontSize: 20)),
        ),
      ),
    );
  }
}

