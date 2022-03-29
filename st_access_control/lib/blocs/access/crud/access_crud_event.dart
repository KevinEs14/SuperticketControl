part of 'access_crud_bloc.dart';

abstract class AccessCrudEvent extends Equatable {
  const AccessCrudEvent();
}

class AccessCrudRegister extends AccessCrudEvent{
  final String ticketAccessId;
  final int qty;
  final String note;

  const AccessCrudRegister({@required this.ticketAccessId, @required this.qty, @required this.note,});

  @override
  List<Object> get props => [ticketAccessId, qty];

  @override
  String toString() => 'Register{$ticketAccessId, $qty}';
}

class AccessCrudLock extends AccessCrudEvent{
  final String ticketAccessId;
  final String note;

  const AccessCrudLock({@required this.ticketAccessId, @required this.note});

  @override
  List<Object> get props => [ticketAccessId, note];

  @override
  String toString() => 'Lock {$ticketAccessId, $note}';
}

class AccessCrudUnlock extends AccessCrudEvent{
  final String ticketAccessId;
  final String note;

  const AccessCrudUnlock({@required this.ticketAccessId, @required this.note});

  @override
  List<Object> get props => [ticketAccessId, note];

  @override
  String toString() => 'Unlock {$ticketAccessId, $note}';
}