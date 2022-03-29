part of 'access_form_bloc.dart';

abstract class AccessFormEvent extends Equatable {
  const AccessFormEvent();

  @override
  List<Object> get props => [];
}

class AccessFormUpdateData extends AccessFormEvent {
  final dynamic value;
  final AccessFormData typeData;

  const AccessFormUpdateData({@required this.value, @required this.typeData});

  @override
  List<Object> get props => [value, typeData];

  @override
  String toString() => 'AccessFormUpdateData {value:$value, type:$typeData}';
}

class AccessFormValidate extends AccessFormEvent {}

class AccessFormValidateLock extends AccessFormEvent {}

class AccessFormValidateUnlock extends AccessFormEvent {}

enum AccessFormData {
  STATUS,
  NOTE,
  QUANTITY,
}