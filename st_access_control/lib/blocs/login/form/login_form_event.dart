part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class LoginFormLoadLists extends LoginFormEvent {}

class LoginFormUpdateData extends LoginFormEvent {
  final dynamic value;
  final LoginFormData typeData;

  const LoginFormUpdateData({@required this.value, @required this.typeData});

  @override
  List<Object> get props => [value, typeData];

  @override
  String toString() => 'LoginFormUpdateData {value:$value, type:$typeData}';
}

class LoginFormValidate extends LoginFormEvent {}

enum LoginFormData {
  STATUS,
  USERNAME,
  PASSWORD,
  SHOW_PASSWORD,
}
