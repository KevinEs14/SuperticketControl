part of 'access_form_bloc.dart';

enum AccessAction{REGISTER_ACCESS, LOCK, UNLOCK}

class AccessFormState extends Equatable {
  final MyFormStatus status;
  final TicketAccessModel ticketAccess;
  final int quantity;
  final AccessAction accessAction;

  AccessFormState({
    @required this.status,
    @required this.ticketAccess,
    @required this.quantity,
    @required this.accessAction,
  });

  @override
  List<Object> get props => [status, ticketAccess, quantity, accessAction];

  @override
  String toString() => 'AccessFormState {status:$status, $ticketAccess, $quantity, $accessAction}';

  AccessFormState copyWith({
    MyFormStatus status,
    TicketAccessModel ticketAccess,
    int quantity,
    AccessAction accessAction,
  }) {
    return AccessFormState(
      status: status ?? this.status,
      ticketAccess: ticketAccess ?? this.ticketAccess,
      quantity: quantity ?? this.quantity,
      accessAction: accessAction ?? this.accessAction,
    );
  }

  static AccessFormState initial (TicketAccessModel ticketAccess) {
    return AccessFormState(
      status: MyFormStatus.INITIAL,
      ticketAccess: ticketAccess,
      quantity: 1,
      accessAction: null,
    );
  }

  bool get disabledWidgets => this.status == MyFormStatus.IN_PROGRESS || this.status == MyFormStatus.SUCCESS;

  bool get autoValidate => this.status == MyFormStatus.INITIAL;

  String get isValidNote => this.ticketAccess?.note == null || this.ticketAccess.note.isEmpty
      ? 'Ingrese el motivo o una nota'
      : null;

  String get isValidQuantity => this.quantity == null || this.quantity < 1
          ? 'Ingrese una cantidad valida'
          : null;

}