import 'package:meta/meta.dart';

import 'error_reponse_spring_model.dart';

class ErrorModel {
  static const String timeout_message = 'La solicitud actual no se puede completar por favor comprueba tu conexión o vuelve a intentar dentro de unos minutos.';
  static const String without_connection_message = "Ups, parece que hay un problema de conexión, por favor comprueba tu conexión";
  static const String server_down = "No pudimos conectarnos al servidor, esto puede ser una falla temporal. Por favor vuelve a intentar dentro de unos minutos.";
  static const String server_off = "Servidor fuera de servicio. Por favor vuelve a intentar dentro de unos minutos.";

  static const int CODE_101 = 101;
  static const int CODE_111 = 111;
  static const int CODE_113 = 113;
  static const int CODE_TIMEOUT = 0;

  final int code;
  final String message;
  final ErrorResponseSpringModel errorResponse;

  ErrorModel({
    @required this.code,
    @required this.message,
    @required this.errorResponse,
  });

  bool get isOffline => code == CODE_101 || code == CODE_111 || code == CODE_TIMEOUT;

  static ErrorModel fromJson(Map<String, dynamic> json) {
    if(json == null || json.isEmpty) return null;

    return ErrorModel(
      code: json['code'],
      message: json['message'],
      errorResponse: ErrorResponseSpringModel.fromJson(json),
    );
  }

  static ErrorModel get withoutConnection101 {
    return ErrorModel(
      code: CODE_101,
      message: without_connection_message,
      errorResponse: null,
    );
  }

  static ErrorModel get serverDown111 {
    return ErrorModel(
      code: CODE_111,
      message: server_down,
      errorResponse: null,
    );
  }

  static ErrorModel get serverOff113 {
    return ErrorModel(
      code: CODE_113,
      message: server_off,
      errorResponse: null,
    );
  }

  static ErrorModel get timeoutError {
    return ErrorModel(
      code: CODE_TIMEOUT,
      message: timeout_message,
      errorResponse: null,
    );
  }

  String getMessage() {
    if (this.errorResponse != null) {
      return this.errorResponse?.errorMessage;
    }

    return this.message;
  }
}
