part of 'event_tickets_bloc.dart';

abstract class EventTicketsEvent extends Equatable {
  const EventTicketsEvent();
}

class EventCrudSearchTicket extends EventTicketsEvent {
  final String eventId;
  final String accessCode;

  const EventCrudSearchTicket({@required this.eventId, @required this.accessCode});

  @override
  List<Object> get props => [eventId];

  @override
  String toString() => 'EventCrudSearchTicket {eventId:$eventId, $accessCode}';
}
class EventTicketsInit extends EventTicketsEvent{

  @override
  List<Object> get props => [];
}
class EventTicketsRegister extends EventTicketsEvent{
  final TicketModel ticket;

  EventTicketsRegister({@required this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() {
    return 'EventTicketsRegister{ticket: $ticket}';
  }
}
