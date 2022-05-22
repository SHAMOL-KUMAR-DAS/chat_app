import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor    = Color(0xFF0ab59a);
  static const Color secondaryColor  = Colors.black12;
  static const Color white           = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xfff3f2ee);
  static const Color grey            = Colors.grey;
  static const Color error           = Colors.redAccent;
  static const Color appBar          = Color(0xFFd8d9de);
  static const Color textColor       = Color(0xff001f3f);
  static const Color darkShadow      = Color(0xffcfceca);

  static const softShadows = [
    BoxShadow(
        color: darkShadow,
        offset: Offset(2.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
    BoxShadow(
        color: white,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
  ];

  static const softShadowsInvert = [
    BoxShadow(
        color: white,
        offset: Offset(2.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 2.0),
    BoxShadow(
        color: darkShadow,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 2.0),
  ];

  static const buttonStyle = TextStyle(color: backgroundColor, fontSize: 18,fontWeight: FontWeight.w800);
}