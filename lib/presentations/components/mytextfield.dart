import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color? backgroundColor;
  final Function(String)? onChanged;
  final String? errorText;
  final bool isPasswordToggle;
  final IconData passwordToggleIcon;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.backgroundColor,
    this.onChanged,
    this.errorText,
    this.isPasswordToggle = false,
    this.passwordToggleIcon = Icons.visibility,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: widget.isPasswordToggle
                ? !_isPasswordVisible
                : widget.obscureText,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                fillColor: widget.backgroundColor ?? Colors.grey.shade100,
                filled: true,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: widget.isPasswordToggle
                    ? IconButton(
                        icon: _isPasswordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                    : null),
          ),
          if (widget.errorText != null)
            Text(
              widget.errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            )
        ],
      ),
    );
  }
}
