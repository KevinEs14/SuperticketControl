
enum ErrorKey {
  UNAUTHORIZED,
  BAD_CREDENTIALS,
  USER_NOT_FOUND,
  USER_NOT_SUFFICIENT_PERMISSIONS,
  INSUFFICIENT_PERMISSIONS,
}

extension ErrorKeyExtension on ErrorKey {
  String get messageES {
    switch(this) {
      case ErrorKey.UNAUTHORIZED:
        return 'Se requiere autenticación para acceder a este servicio. Por favor inicie sesión nuevamente.';
      case ErrorKey.BAD_CREDENTIALS:
      case ErrorKey.USER_NOT_FOUND:
        return "El usuario o la contraseña es incorrecto";
      case ErrorKey.USER_NOT_SUFFICIENT_PERMISSIONS:
      case ErrorKey.INSUFFICIENT_PERMISSIONS:
        return 'El usuario no tiene permisos para realizar esta acción';
      default:
        return null;
    }
  }
}