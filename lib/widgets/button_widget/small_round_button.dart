import 'package:flutter/material.dart';
class SRoundbutton extends StatelessWidget {
  final String title;
  final bool loading;
  final void Function()? ontap;

  const SRoundbutton({Key? key,required this.title,this.ontap,this.loading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 30,
        width: 130,
        decoration: BoxDecoration(
          color:  const Color.fromARGB(225, 226, 236, 185),
          borderRadius: BorderRadius.circular(8),

        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Color.fromARGB(255, 8, 8, 8),) :
          Text(title,style: const TextStyle(color: Colors.black,fontSize: 13)),
        ),
      ),
    );
  }
}

