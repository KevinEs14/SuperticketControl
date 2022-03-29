part of 'event_tickets_bloc.dart';

abstract class EventTicketsState extends Equatable {
  const EventTicketsState();

  @override
  List<Object> get props => [];
}

class EventTicketsInitial extends EventTicketsState {}

class EventTicketsLoadInProgress extends EventTicketsState {}

class EventTicketsLoadedSuccess extends EventTicketsState {
  final List<TicketModel> tickets;
  final String accessCode;

  const EventTicketsLoadedSuccess({@required this.tickets, @required this.accessCode,});

  @override
  List<Object> get props => [tickets, accessCode];

  @override
  String toString() => 'EventTicketsLoadedSuccess {tickets:$tickets, $accessCode}';
}
class EventTicketsRegisterSuccess extends EventTicketsState {
  final TicketAccessModel ticket;

  const EventTicketsRegisterSuccess({@required this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'EventTicketsRegisterSuccess {ticket:$ticket}';
}
class EventTicketsLoadedFailure extends EventTicketsState {
  final String error;

  const EventTicketsLoadedFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EventTicketsLoadedFailure {error:$error}';
}