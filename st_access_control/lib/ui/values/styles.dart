import 'package:flutter/painting.dart';

import 'colors.dart';

abstract class Styles {

  static const TextStyle t31w7TS = TextStyle(
    fontSize: 31.0,
    fontWeight: FontWeight.w700,
    color: colorSecondaryVariant,
    letterSpacing: -1.0,
    wordSpacing: 3,
  );

  static const TextStyle titleAppbar = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: colorPrimary,
  );

  // LIST
  static const TextStyle titleToList = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: colorText,
    letterSpacing: 0.2,
  );

  static const TextStyle subtitleToList = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: colorTextSecondary,
    letterSpacing: 0.3,
  );

  static const TextStyle trailingToList = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: colorTextSecondary,
  );

  //DETAIL TITLE
  static const TextStyle titleDetailSmallTextSecondary = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: colorTextSecondary,
  );

  static const TextStyle titleDetailSmallPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: colorSecondary,
  );

  static const TextStyle titleDetailSmallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: colorText,
    letterSpacing: -0.3,
  );

  //DETAIL TEXT
  static const TextStyle textDetailLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: colorText,
  );

  static const TextStyle textDetailSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: colorText,
  );

  // FORMS
  static const TextStyle titleToForm = TextStyle(
    fontSize: 13, //0.75*textTheme.subtitle1.fontSize
    fontWeight: FontWeight.w500,
    color: colorTextSecondary,
  );

  static const TextStyle link = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: colorLink,
    decoration: TextDecoration.underline,
  );

  static const TextStyle errorForm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: colorError,
  );
}
