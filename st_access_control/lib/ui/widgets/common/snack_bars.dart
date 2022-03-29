import 'package:flutter/material.dart';

import '../../values/values.dart';

class LoadingSnackBar extends SnackBar {
  LoadingSnackBar({
    Key key,
    int duration: 60,
    @required String text,
  }) : super(
    key: key,
    duration: Duration(seconds: duration),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$text'),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(colorSecondary),
        ),
      ],
    ),
  );
}

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({
    Key key,
    @required String text,
  }) : super(
    key: key,
    backgroundColor: colorSuccess,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )),
        Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        )
      ],
    ),
  );
}

class ErrorSnackBar extends SnackBar {

  static const String _retry = "Reintentar";

  ErrorSnackBar({
    Key key,
    VoidCallback retry,
    @required String text,
  }) : super(
    key: key,
    backgroundColor: colorError,
    duration: Duration(seconds: retry == null ? 5 : 365),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )),
        retry == null ? Icon(Icons.error) : const SizedBox.shrink()
      ],
    ),
    action: retry != null
        ? SnackBarAction(
      label: _retry.toUpperCase(),
      textColor: Colors.white,
      onPressed: retry,
    )
        : null,
  );
}

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key key,
    @required String text,
    @required IconData icon,
    @required Color bgColor,
    @required Color textColor,
  }) : super(
    key: key,
    backgroundColor: bgColor,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            )),
        Icon(
          icon,
          color: textColor,
        )
      ],
    ),
  );
}

showSuccessSnackBar({
  BuildContext context,
  GlobalKey<ScaffoldState> globalKey,
  @required String text,
}) {
  _showSnackBar(context, globalKey, SuccessSnackBar(key: Keys.successSnackBar, text: text));
}

showLoadingSnackBar({
  BuildContext context,
  GlobalKey<ScaffoldState> globalKey,
  @required String text,
}) {
  _showSnackBar(context, globalKey, LoadingSnackBar(key: Keys.loadingSnackBar, text: text));
}

showErrorSnackBar({
  BuildContext context,
  GlobalKey<ScaffoldState> globalKey,
  @required String text,
  VoidCallback retry,
}) {
  _showSnackBar(context, globalKey, ErrorSnackBar(key: Keys.errorSnackBar, text: text, retry: retry));
}

showCustomSnackBar({
  BuildContext context,
  GlobalKey<ScaffoldState> globalKey,
  @required String text,
  @required IconData icon,
  @required Color bgColor,
  @required Color textColor,
}) {
  _showSnackBar(context, globalKey, CustomSnackBar(key: Keys.customSnackBar, text: text, icon: icon, bgColor: bgColor, textColor: textColor));
}

void _showSnackBar(BuildContext context, GlobalKey<ScaffoldState> globalKey,
    SnackBar snackBar) {
  if (context != null) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        snackBar,
      );
  } else if (globalKey != null) {
    globalKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        snackBar,
      );
  }
}
