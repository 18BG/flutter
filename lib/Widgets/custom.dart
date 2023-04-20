import 'package:flutter/material.dart';

class CustomText extends Text {
  CustomText(String texte,
      {super.key,
      weiht: FontWeight.normal,
      color = Colors.white,
      textAlign = TextAlign.center,
      fontStyle: FontStyle.italic,
      factor = 1.0})
      : super(texte,
            textAlign: textAlign,
            textScaleFactor: factor,
            style: TextStyle(
                color: color, fontStyle: fontStyle, fontWeight: weiht));
}
