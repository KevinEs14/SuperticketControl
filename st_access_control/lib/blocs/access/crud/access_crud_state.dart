part of 'access_crud_bloc.dart';

abstract class AccessCrudState extends Equatable {
  const AccessCrudState();

  @override
  List<Object> get props => [];
}

class AccessCrudInitial extends AccessCrudState {}

class AccessCrudInProgress extends AccessCrudState {}

class AccessCrudSuccess extends AccessCrudState {
  final TicketAccessModel access;
  final CrudOn on;

  const AccessCrudSuccess({@required this.access, @required this.on});

  @override
  List<Object> get props => [access, on];

  @override
  String toString() => 'AccessCrudSuccess {access:$access, on:$on}';
}

class AccessCrudFailure extends AccessCrudState {
  final String error;
  final CrudOn on;

  const AccessCrudFailure({@required this.error, @required this.on});

  @override
  List<Object> get props => [error, on];

  @override
  String toString() => 'AccessCrudFailure {error:$error, on:$on}';
}