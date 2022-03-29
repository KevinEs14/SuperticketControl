part of 'event_crud_bloc.dart';

abstract class EventCrudState extends Equatable {
  final String eventId;
  const EventCrudState(this.eventId);

  @override
  List<Object> get props => [];
}

class EventCrudInitial extends EventCrudState {
  const EventCrudInitial() : super(null);
}

class EventCrudInProgress extends EventCrudState {
  const EventCrudInProgress(String eventId) : super(eventId);
}

class EventCrudSuccess extends EventCrudState {
  final List<TicketBookAccessedModel> ticketsAccesses;
  final int totalTickets;
  final int totalTicketsRead;

  const EventCrudSuccess({
    @required this.ticketsAccesses,
    @required this.totalTickets,
    @required this.totalTicketsRead,
    @required String eventId,
  }): super(eventId);

  @override
  List<Object> get props => [ticketsAccesses, totalTickets, totalTicketsRead];

  @override
  String toString() => 'EventCrudSuccess {tickets:$ticketsAccesses, $totalTickets, $totalTicketsRead}';
}

class EventCrudFailure extends EventCrudState {
  final String error;

  const EventCrudFailure({@required this.error,
    @required String eventId,}): super(eventId);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EventCrudFailure {error:$error}';
}
