class Validator {
  static const String _errorUserName = "Ingrese el nombre de usuario válido";
  static const String _errorPassword = "La contraseña debe tener al menos 4 caracteres";

  static const String _errorEmail = "Por favor ingrese un correo válido";
  static const String _errorInput = "Este campo no puede ser vacío";
  static const String _errorInput4 = "Este campo debe tener al menos 4 caracteres";
  static const String _errorInput2 = "Este campo debe tener al menos 2 caracteres";

  static const String _kUserNameRule = r"^([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)|^([a-zA-Z0-9_.+-]+$)";
  static String username(String text) {
    final RegExp regExp = new RegExp(_kUserNameRule);

    if (!regExp.hasMatch(text.trim()) || text.isEmpty || text.length > 49) {
      return _errorUserName;
    } else {
      return null;
    }
  }

  static String password(String password) {
    if (password.length < 4 || password.length > 35) {
      return _errorPassword;
    } else {
      return null;
    }
  }

  static const String _kEmailRule = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";
  static String email(String email) {
    final RegExp emailExp = new RegExp(_kEmailRule);

    if (!emailExp.hasMatch(email.trim()) || email.isEmpty || email.length > 49) {
      return _errorEmail;
    } else {
      return null;
    }
  }

  static String input(String text) {
    if (text == null || text.isEmpty) {
      return _errorInput;
    }
    return null;
  }

  static String inputMin2Chars(String string) {
    if (string.length >= 2) {
      return null;
    } else if(string.isEmpty){
      return _errorInput;
    }
    return _errorInput2;
  }

  static String inputMin4Chars(String string) {
    if (string.length >= 4) {
      return null;
    } else if(string.isEmpty){
      return _errorInput;
    }
    return _errorInput4;
  }

  static String select(dynamic itemSelect) {
    if (itemSelect == null) {
      return _errorInput;
    }
    return null;
  }
}