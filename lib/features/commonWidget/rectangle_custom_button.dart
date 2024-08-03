import 'package:flutter/material.dart';

class RectangleCustomButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final Color buttonBackgroundColor;
  final Widget icon;
  const RectangleCustomButton(
      {super.key,
        required this.buttonText,
        required this.onPressed,
        this.icon = const SizedBox(),
        this.buttonBackgroundColor = const Color.fromRGBO(28, 28, 30, 1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                5.0), // Adjust the border radius as needed
          ),
          backgroundColor: buttonBackgroundColor,
          padding:
          const EdgeInsets.all(15.0), // Set the button color to transparent
          elevation: 0, // Remove elevation
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // Text color
                fontSize: 16.0, // Text size
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: icon,
            )
          ],
        ),

      ),
    );
  }
}
