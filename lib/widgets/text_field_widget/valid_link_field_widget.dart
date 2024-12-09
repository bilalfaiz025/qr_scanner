import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ValidTextFieldWidget extends StatefulWidget {
  final String labeltxt;
  final IconData? sufixicon;
  final TextEditingController? controller;
  final TextInputType? typeinput;
  final GlobalKey? formkey;
  bool? obscure;

  ValidTextFieldWidget({
    required this.labeltxt,
    this.sufixicon,
    this.typeinput,
    this.formkey,
    this.controller,
    this.obscure,
    super.key,
  });

  @override
  State<ValidTextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<ValidTextFieldWidget> {
  final formKey = GlobalKey<FormState>();
  final textFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: TextFormField(
          controller: widget.controller,
          key: textFieldKey,
          decoration: InputDecoration(
            label: Text(widget.labeltxt),
            suffixIcon: widget.sufixicon != null
                ? Icon(widget.sufixicon)
                : null, 
          ),
          onChanged: (v) => textFieldKey.currentState?.validate(),
          validator: (v) {
            String? message;
            if (!isValidURL(v)) {
              message ??= '';
              message += 'Provide Invalid URL';
            }
            return message;
          },
        ),
      ),
    );
  }

  bool isValidURL(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final RegExp urlRegex = RegExp(
      r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$",
      caseSensitive: false,
    );
    return urlRegex.hasMatch(value);
  }
}
