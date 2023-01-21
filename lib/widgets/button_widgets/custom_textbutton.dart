// ignore_for_file: must_be_immutable
// ignore_for_file: const

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    required this.buttonBorderRadius,
    required this.buttonFunction,
    required this.buttonText,
    this.buttonColor = const Color(0xff7be5e7),
    this.buttonTextColor = Colors.black,
    Key? key,
  }) : super(key: key);

  BorderRadiusGeometry buttonBorderRadius;
  void Function()? buttonFunction;
  String buttonText;
  Color buttonColor;
  Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: buttonBorderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: TextButton(
        onPressed: buttonFunction,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: buttonTextColor,
            ),
          ),
        ),
      ),
    );
  }
}