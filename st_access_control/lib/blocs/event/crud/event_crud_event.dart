part of 'event_crud_bloc.dart';

abstract class EventCrudEvent extends Equatable {
  const EventCrudEvent();

  @override
  List<Object> get props => [];
}

class EventCrudInitialize extends EventCrudEvent {}

class EventCrudReadTotalTickets extends EventCrudEvent {
  final String eventId;

  const EventCrudReadTotalTickets({@required this.eventId});

  @override
  List<Object> get props => [eventId];

  @override
  String toString() => 'EventCrudReadTotalTickets {eventId:$eventId}';
}

class EventCrudRefresh extends EventCrudEvent {}