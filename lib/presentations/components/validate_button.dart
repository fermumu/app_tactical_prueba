import 'package:flutter/material.dart';

class ValidateButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const ValidateButton({
    required this.buttonText,
    required this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22)))),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 19, color: Colors.grey),
        ),
      ),
    );
  }
}
