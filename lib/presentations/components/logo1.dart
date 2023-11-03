import 'package:flutter/material.dart';

Widget imageLogo1({double? height, double? width}) {
  return Column(
    children: [
      Center(
        child: ClipOval(
          child: Image.asset(
            'assets/images_company/del.jpg',
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  );
}
