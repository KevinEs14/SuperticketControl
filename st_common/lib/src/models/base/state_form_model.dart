import 'package:meta/meta.dart';

enum MyFormStatus{INITIAL, IN_PROGRESS, SUCCESS, FAILURE, FORM_LOAD_INITIAL_FAILED, FORM_SUCCESS, FORM_FAILURE}

enum CrudOn {CREATE, READ, UPDATE, DELETE, UPLOAD, DOWNLOAD}

class MyFormStatusModel{
  final MyFormStatus status;
  final String message;
  final CrudOn on;

  const MyFormStatusModel({@required this.status, @required this.message, @required this.on});

  @override
  List<Object> get props => [status, message, on];

  @override
  String toString() => 'MyFormStatusModel {$status, $message, $on}';
}