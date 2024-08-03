import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final Color buttonColor;
  const CustomTextButton(
      {super.key,
        required this.buttonText,
        required this.onPressed,
        this.buttonColor = const Color.fromRGBO(88, 101, 242, 1)});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: buttonColor),
      ),
    );
  }
}
