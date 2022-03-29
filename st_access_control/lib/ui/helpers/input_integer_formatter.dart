import 'package:flutter/services.dart';

RegExp _numeric = RegExp(r'[1-9]');
class IntegerInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {

    String newText;

    if (newValue.selection.baseOffset == 0) {
      newText = '0';
    }else if(newValue.text.startsWith('0'))
      newText = newValue.text.substring(newValue.text.indexOf(_numeric), newValue.text.length);
    else
      newText = newValue.text;


    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}