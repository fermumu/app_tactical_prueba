import 'package:flutter/material.dart';

class TextAndTextButtom extends StatelessWidget {
  final String questionText;
  final String linkText;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final MainAxisAlignment? mainAxisAlignment;

  const TextAndTextButtom(
      {required this.questionText,
      required this.linkText,
      required this.onPressed,
      this.padding,
      this.mainAxisAlignment,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Text(
            questionText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: onPressed,
              child: Text(
                linkText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
