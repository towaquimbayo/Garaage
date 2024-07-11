import 'package:flutter/material.dart';

class AppText {
  // Heading
  static const headH1 = TextStyle(fontFamily: 'Syne', fontSize: 24, fontWeight: FontWeight.w700);
  static const headH2 = TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w700);
  static const headH3 = TextStyle(fontFamily: 'Syne', fontSize: 16, fontWeight: FontWeight.w700);
  static const headH4 = TextStyle(fontFamily: 'Syne', fontSize: 14, fontWeight: FontWeight.w600);
  static const headH5 = TextStyle(fontFamily: 'Syne', fontSize: 12, fontWeight: FontWeight.w500);

  // Body
  static const bodyXL = TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w400);
  static const bodyL = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400);
  static const bodyM = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400);
  static const bodyS = TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400);
  static const bodyXS = TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w500);

  // Action
  static const actionL = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600);
  static const actionM = TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600);
  static const actionS = TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600);

  // Caption
  static const caption = TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  // Semantic
  static const headingText = headH1;
  static const pageTitleText = headH4;
  static const bodyText = bodyM;
  static const taglineText = bodyS;
  static const buttonText = actionM;
}
