import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomForm extends StatefulWidget {
  final String labeltxt;
  IconData? sufixicon;
  final TextEditingController? controller;
  final TextInputType? typeinput;
  bool? obscure;
  CustomForm(
      {required this.labeltxt,
      this.sufixicon,
      this.typeinput,
      this.controller,
      this.obscure,
      Key? key})
      : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  final passwordFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: TextFormField(
          obscureText: _passwordVisible,
          controller: widget.controller,
          key: passwordFieldKey,
          inputFormatters: [
            LengthLimitingTextInputFormatter(124)
          ],
          
          decoration: InputDecoration(
              label: Text(widget.labeltxt),
              
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
              )),
          onChanged: (v) => passwordFieldKey.currentState?.validate(),
          validator: (v) {
            String? message;
            if (!RegExp('.*[A-Z].*').hasMatch(v ?? '')) {
              message ??= '';
              message += 'Password should contain an uppercase letter A-Z. ';
            }
            else if (!RegExp(".*[0-9].*").hasMatch(v ?? '')) {
              message ??= '';
              message += 'Password should contain a numeric value 1-9. ';
            }
            else if (!RegExp('.*[a-z].*').hasMatch(v ?? '')) {
              message ??= '';
              message += 'Password should contain a lowercase letter a-z. ';
            }
            else if (!RegExp("[@._*^&!-]").hasMatch(v ?? '')) {
              message ??= '';
              message += 'Password should contain an special character @-_. ';
            }
            return message;
          },
        ),
      ),
    );
  }
}
