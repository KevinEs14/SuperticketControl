import 'package:flutter/material.dart';

import '../values/values.dart';

class MyAlertDialog extends StatelessWidget {
  static const double avatarRadius = 36.0;
  static const String _textCancelButton = 'Cancelar';
  static const String _textAcceptButton = 'Aceptar';

  final IconData iconData;
  final String title, description, acceptButton;
  final VoidCallback onPressedAccept;
  final Color bgColorIcon;
  final Color colorIcon;

  MyAlertDialog({
    @required this.iconData,
    @required this.title,
    @required this.description,
    this.acceptButton : _textAcceptButton,
    this.onPressedAccept,
    this.bgColorIcon: colorPrimary,
    this.colorIcon: colorOnPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.normal),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + Dimens.normal,
            bottom: Dimens.normal,
            left: Dimens.normal,
            right: Dimens.normal,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Dimens.normal),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlatButton(
                      child: Text(onPressedAccept != null ? _textCancelButton : _textAcceptButton),
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                    ),
                    onPressedAccept != null
                        ? FlatButton(
                            child: Text(acceptButton),
                            onPressed: onPressedAccept,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Dimens.normal,
          right: Dimens.normal,
          child: Container(
            width: avatarRadius*2,
            height: avatarRadius*2,
            decoration: BoxDecoration(
              color: bgColorIcon,
              shape: BoxShape.circle,
//              borderRadius: BorderRadius.circular(avatarRadius),
            ),
            child: Icon(iconData, color: colorIcon, size: avatarRadius),
          ),
        ),
      ],
    );
  }
}
