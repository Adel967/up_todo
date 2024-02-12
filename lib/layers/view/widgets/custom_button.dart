import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.withBackground,
      required this.title,
      required this.function});

  final bool withBackground;
  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => function(),
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
            backgroundColor: MaterialStateProperty.all(
                withBackground ? ThemeColors.secondary : Colors.transparent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              side: withBackground
                  ? BorderSide(
                      width: 0,
                    )
                  : BorderSide(width: 1, color: Colors.white.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(4),
            ))),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ));
  }
}
