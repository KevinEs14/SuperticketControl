import 'package:flutter/material.dart';

class OpacityInPercentage {
  static const String p100 = 'FF';
  static const String p95 = 'F2';
  static const String p90 = 'E6';
  static const String p85 = 'D9';
  static const String p80 = 'CC';
  static const String p75 = 'BF';
  static const String p70 = 'B3';
  static const String p65 = 'A6';
  static const String p60 = '99';
  static const String p55 = '8C';
  static const String p50 = '80';
  static const String p45 = '73';
  static const String p40 = '66';
  static const String p35 = '59';
  static const String p30 = '4D';
  static const String p25 = '40';
  static const String p20 = '33';
  static const String p15 = '26';
  static const String p10 = '1A';
  static const String p5 = '0D';
  static const String p0 = '00';
}

class HexColor extends Color {

  HexColor(final String hexColor, [String alpha = OpacityInPercentage.p100]) : super(_getColorFromHex(hexColor, alpha));

  static int _getColorFromHex(String hexColor, [String alpha]) {
    if(hexColor == null || hexColor.isEmpty) return null;

    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = alpha + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}