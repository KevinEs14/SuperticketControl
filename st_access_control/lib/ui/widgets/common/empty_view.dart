import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  static const String titleDefault = "No hay nada Aqui";
  static const String messageDefault = "No hay elementos en esta lista";

  static const String titleSearch = "No se encontraron resultados";
  static const String messageSearch = "Intente con otro filtro o palabra de búsqueda";

  static const String retry = "Intentar nuevamente";

  final String image;
  final IconData icon;
  final String titleEmpty;
  final String messageEmpty;
  final String textButton;
  final VoidCallback onPressed;

  EmptyView._(this.image, this.icon, this.titleEmpty, this.messageEmpty,
      this.textButton, this.onPressed);

  factory EmptyView({
    bool isSearch : false,
    String image,
    IconData icon,
    String title,
    String message,
    String nameModels,
    String nameModel,
    String textButton,
    VoidCallback onPressed,
  }) {
    String _title;
    String _message;

    if (title == null) {
      if (isSearch) {
        _title = titleSearch;
      } else {
        if (nameModels != null && nameModels.isNotEmpty) {
          _title = 'No hay $nameModels';
        } else {
          _title = titleDefault;
        }
      }
    } else {
      _title = title;
    }

    if (message == null) {
      if (isSearch) {
        _message = messageSearch;
      } else {
        if (nameModel != null && nameModel.isNotEmpty) {
          _message = 'Cualquier $nameModel nuevo se mostrará aquí';
        } else {
          _message = messageDefault;
        }
      }
    } else {
      _message = message;
    }

    return EmptyView._(
      image,
      icon ?? (isSearch ? Icons.search : Icons.insert_drive_file_outlined),
      _title,
      _message,
      textButton ?? retry,
      onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image != null
              ? Image.asset(image, fit: BoxFit.fitHeight)
              : Icon(icon, color: Colors.grey[300], size: 72),
          Text(titleEmpty, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 6.0, 32.0, 32.0),
            child: Text(messageEmpty, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ),
          textButton != null && icon != null && onPressed != null
              ? RaisedButton(
                  child: Text(textButton),
                  onPressed: onPressed,
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
