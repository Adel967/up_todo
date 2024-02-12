import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTextFieldWithTitle extends StatelessWidget {
  const CustomTextFieldWithTitle(
      {super.key,
      required this.title,
      required this.hintText,
      required this.textEditingController,
      required this.textInputType,
      this.val,
      this.isSecure = false});

  final String title;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool isSecure;
  final Function(String)? val;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: textEditingController,
          keyboardType: textInputType,
          style: TextStyle(color: Colors.white),
          obscureText: isSecure,
          validator: (text) {
            if (text != null) {
              if (text!.isEmpty) {
                return "Fill all fields";
              }
              if (val != null) {
                return val!(text!);
              }
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            fillColor: Color(0XFF1D1D1D),
            filled: true,
            hintText: hintText,
            isDense: true,
            hintStyle:
                TextStyle(color: Colors.white.withOpacity(.7), fontSize: 16),
          ),
        )
      ],
    );
  }
}
