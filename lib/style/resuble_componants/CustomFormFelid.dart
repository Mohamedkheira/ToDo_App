import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);
class CustomFormField extends StatefulWidget {
  String label;
  TextInputType type;
  TextInputAction textInputAction;
  bool isPassword;
  Validator validator;
  TextEditingController controller;
  int lines;

  CustomFormField({
    required this.label,
    this.type = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    required this.validator,
    required this.controller,
    this.lines = 1,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.lines,
      maxLines: widget.lines,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.type,
      obscureText: widget.isPassword ? isObscure : false,
      obscuringCharacter: '*',
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.black
        ),

        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: isObscure
                    ? Icon(
                  color: Theme.of(context).primaryColor,
                        Icons.visibility_outlined,
                      )
                    : Icon(
                  color: Theme.of(context).primaryColor,
                        Icons.visibility_off_outlined,
                      ),
              )
            : null,
      ),
    );
  }
}
