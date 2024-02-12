import 'dart:async';
import 'package:flutter/material.dart';
import 'package:up_todo/core/constants/theme.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: ThemeColors.secondary,
        ),
      );
}
