import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

const ButtonThemeData _buttonThemeData = ButtonThemeData(
//  minWidth: 156.0,
  height: 42.0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
  buttonColor: colorPrimary,
  textTheme: ButtonTextTheme.primary,
);

const InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
  alignLabelWithHint: false,
  border: UnderlineInputBorder(),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFbbbbbb)),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: colorSecondary),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
 // errorBorder: UnderlineInputBorder(
 //   borderSide: BorderSide(color: colorError, width: 0.5),
 //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
 // ),
//  focusedErrorBorder: OutlineInputBorder(
//    borderSide: BorderSide(color: colorError, width: 1),
//    borderRadius: BorderRadius.all(Radius.circular(8.0)),
//  ),
  disabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFf6f6f6), width: 2),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
);

const ColorScheme _colorScheme = ColorScheme(
  primary: colorPrimary,
  primaryVariant: colorPrimaryVariant,
  secondary: colorSecondary,
  secondaryVariant: colorSecondaryVariant,
  surface: colorSurface,
  background: colorBackground,
  error: colorError,
  onPrimary: colorOnPrimary,
  onSecondary: colorOnSecondary,
  onSurface: colorOnSurface,
  onBackground: colorText,
  onError: colorOnError,
  brightness: Brightness.light,
);

IconThemeData _iconTheme(IconThemeData original) {
  return original.copyWith(color: colorSecondary);
}

AppBarTheme _buildAppBarTheme(AppBarTheme base) {
  return base.copyWith(
    color: colorAppBar,
    centerTitle: true,
    elevation: 1,
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
          // NAME       SIZE   WEIGHT   SPACING  NAME
          // headline1   96.0   light   -1.5     display4
          // headline2   60.0   light   -0.5     display3=> date in the dialog
          // headline3   48.0   normal   0.0     display2
          // headline4   34.0   normal   0.25    display1
          // headline5   24.0   normal   0.0     headline=> text in dialogs(the month and year in the dialog)
          // headline6   20.0   medium   0.15    title   => app bars and dialogs
          headline6: base.headline6.copyWith(color: colorPrimary, fontWeight: FontWeight.w600),
          // subtitle1    16.0   normal   0.15   subhead=> text in lists (ListTile.title) and inputs.
          subtitle1: base.subtitle1.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
          // subtitle2   14.0   medium   0.1      subtitle => little smaller than subhead.
          // body1      16.0   normal   0.5      body2
          // body2      14.0   normal   0.25     body1 => default text
          // button     14.0   medium   1.25     button =>  text on RaisedButton and FlatButton
          button: base.button.copyWith(fontWeight: FontWeight.w400, fontSize: 15, wordSpacing: 4, letterSpacing: 1),
          // caption    12.0   normal   0.4      caption => text error input
          // overline   10.0   normal   1.5      overline => subtítulos o título más grande
          )
      .apply(
        fontFamily: 'Montserrat',
//        displayColor: colorPrimaryVariant,
//        bodyColor: colorText,
      );
}

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: _colorScheme,
    primaryColor: colorPrimary,
    accentColor: colorSecondary,
    // input
    errorColor: colorError,
    disabledColor: colorDisabled,
    hintColor: colorHint,
    focusColor: colorPrimary,
    cursorColor: colorSecondary,
    // tap
    highlightColor: colorHighlight,
    splashColor: colorSplash,
//    dividerColor: colorDivider,
    cardColor: colorSurface,
    scaffoldBackgroundColor: colorBackground,
    backgroundColor: colorBackground,
    toggleableActiveColor: colorSecondary,
    unselectedWidgetColor: colorSecondary,
    textSelectionColor: colorSecondary,
    buttonTheme: _buttonThemeData,
    inputDecorationTheme: _inputDecorationTheme,
    iconTheme: _iconTheme(base.iconTheme),
    primaryIconTheme: _iconTheme(base.iconTheme),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    appBarTheme: _buildAppBarTheme(base.appBarTheme),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}
