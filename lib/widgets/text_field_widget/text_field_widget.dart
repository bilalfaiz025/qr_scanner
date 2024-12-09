import 'package:flutter/material.dart';


// ignore: must_be_immutable
class EmailTextFieldWidget extends StatefulWidget {
  final String labeltxt;
  final IconData? sufixicon;
  final TextEditingController? controller;
  final TextInputType? typeinput;
  final GlobalKey? formkey;
  bool? obscure;

   EmailTextFieldWidget(
      {required this.labeltxt,
      this.sufixicon,
      this.typeinput,
       this.formkey,
      this.controller,
      this.obscure,
      super.key});

  @override
  State<EmailTextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<EmailTextFieldWidget> {
  final formKey = GlobalKey<FormState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: TextFormField(
            controller: widget.controller,
            key: passwordFieldKey,
            
            decoration: InputDecoration(
                label: Text(widget.labeltxt),
                
            ),
            onChanged: (v) => passwordFieldKey.currentState?.validate(),
            validator: (v) {
              String? message;
             
             if (!RegExp("[@._-]").hasMatch(v ?? '')) {
                message ??= '';
                message += 'Enter Valid Email ';
              }
              return message;
            },
          ),
      ),
    );
  }
}
