import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../values/values.dart';

class FailureView extends StatelessWidget {
  static const String retry = "Reintentar";
  static const String errorUnexpected = "Oops..\nOcurrio un error inesperado";

  final String error;
  final VoidCallback onPressed;

  const FailureView({
    Key key,
    @required this.error,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(56.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline, color: colorError, size: 72),
            SizedBox(height: 16),
            Text(errorUnexpected, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            SizedBox(height: 8),
            Text('${error ?? ''}', style: TextStyle(color: Colors.grey, fontSize: 12),textAlign: TextAlign.center,),
            SizedBox(height: 24),
            RaisedButton(
              child: Text(retry),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

}