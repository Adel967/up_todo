import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveCancelButtons extends StatelessWidget {
  const SaveCancelButtons({
    required this.onSavePressed,
    this.onCancelPressed,
    this.primaryText,
    this.secondaryText,
    this.isPrimaryOnStart = true,
    this.primaryButtonKey,
    this.secondaryButtonKey,
    this.isSecondaryShown = true,
    this.primaryPadding,
    this.secondaryPadding,
    this.radius,
    this.primaryColor,
    Key? key,
  }) : super(key: key);
  final VoidCallback onSavePressed;
  final VoidCallback? onCancelPressed;
  final String? primaryText, secondaryText;
  final bool isPrimaryOnStart, isSecondaryShown;
  final Key? primaryButtonKey, secondaryButtonKey;
  final EdgeInsets? primaryPadding, secondaryPadding;
  final double? radius;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: isPrimaryOnStart
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FilledButton(
                          key: primaryButtonKey,
                          onPressed: onSavePressed,
                          style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: primaryColor ?? Colors.green),
                          child: Text(
                            primaryText ?? "Ok",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.black),
                          )),
                    ),
                    if (isSecondaryShown)
                      SizedBox(
                        width: 20,
                      ),
                    if (isSecondaryShown)
                      Expanded(
                        child: FilledButton(
                            key: secondaryButtonKey,
                            onPressed: onCancelPressed,
                            style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: Colors.grey.shade400),
                            child: Text(
                              secondaryText ?? "Cancel",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black),
                            )),
                      ),
                  ],
                ),
              )
            : IntrinsicHeight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isSecondaryShown)
                        Expanded(
                          child: FilledButton(
                              key: secondaryButtonKey,
                              onPressed: onCancelPressed,
                              style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: Colors.grey.shade400),
                              child: Text(
                                secondaryText ?? "Ok",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black),
                              )),
                        ),
                      if (isSecondaryShown)
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: FilledButton(
                            key: primaryButtonKey,
                            onPressed: onSavePressed,
                            style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: primaryColor ?? Colors.green),
                            child: Text(
                              primaryText ?? "Save",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black),
                            )),
                      ),
                    ]),
              ),
      );
}
