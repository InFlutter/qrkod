
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  Color? color;
  double? size;
  FontWeight? fontWeight;
  TextAlign? textAlign;

  CustomText({
    super.key,
    this.color,
    this.fontWeight,
    this.size,
    this.textAlign,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
      ),
    );
  }
}
