import 'package:flutter/material.dart';


// ignore: must_be_immutable
class TextFieldWidget extends StatefulWidget {
  final String labeltxt;
  final IconData? sufixicon;
  final TextEditingController? controller;
  final TextInputType? typeinput;
  final GlobalKey? formkey;
  bool? obscure;

   TextFieldWidget(
      {required this.labeltxt,
      this.sufixicon,
      this.typeinput,
       this.formkey,
      this.controller,
      this.obscure,
      super.key});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final formKey = GlobalKey<FormState>();
  final fieldKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: TextFormField(
            controller: widget.controller,
            key: fieldKey,
            
            decoration: InputDecoration(
                label: Text(widget.labeltxt),
                
            ),
            onChanged: (v) => fieldKey.currentState?.validate(),
            validator: (v) {
              String? message;
              if (!RegExp('.*[A-Z].*').hasMatch(v ?? '')) {
                message ??= '';
                message += 'Field should contain an uppercase letter A-Z. ';
              }
              return message;
            },
          ),
      ),
    );
  }
}
