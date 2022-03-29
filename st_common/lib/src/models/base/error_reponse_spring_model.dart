import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../helpers/enum_helper.dart';
import 'error_config.dart';

class ErrorResponseSpringModel extends Equatable {
  final String type;
  final String title;
  final int status;
  final String detail;
  final String path;
  final String message;
  final ErrorKey errorKey;

  ErrorResponseSpringModel({
    @required this.type,
    @required this.title,
    @required this.status,
    @required this.detail,
    @required this.path,
    @required this.message,
    @required this.errorKey,
  });

  @override
  List<Object> get props => [type, title, status, detail, path, message, errorKey];

  @override
  String toString() => 'ErrorResponseSpringModel {$title, $status,  $detail, $errorKey}';

  ErrorKey get toErrorKey => this.title != null && this.title.isNotEmpty
      ? stringToEnum<ErrorKey>(ErrorKey.values, this.title.toUpperCase())
      : null;

  String get errorMessage {
    if (this.errorKey != null) {
      return this.errorKey.messageES;
    } else if (this.title != null) {
      return '${toErrorKey?.messageES ?? this.title}';
    } else if (this.detail != null) {
      return '${this.detail ?? ''}';
    } else {
      return this.status?.toString() ?? 'Error inesperado';
    }
  }

  ErrorResponseSpringModel copyWith({
    String type,
    String title,
    int status,
    String detail,
    String path,
    String message,
    ErrorKey errorKey,
  }) {
    return ErrorResponseSpringModel(
      type: type ?? this.type,
      title: title ?? this.title,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      path: path ?? this.path,
      message: message ?? this.message,
      errorKey: errorKey ?? this.errorKey,
    );
  }

  static ErrorResponseSpringModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    final String _errorKey = json['error_key'] ?? json['errorKey'];

    return ErrorResponseSpringModel(
      type: json['type'],
      title: json['title'],
      status: json['status'],
      detail: json['detail'],
      path: json['path'],
      message: json['message'],
      errorKey: stringToEnum<ErrorKey>(ErrorKey.values, _errorKey?.toUpperCase()),
    );
  }
}