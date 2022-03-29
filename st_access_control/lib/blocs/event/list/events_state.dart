part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoadInProgress extends EventsState {}

class EventsLoadedSuccess extends EventsState {
  final List<EventModel> events;

  const EventsLoadedSuccess({@required this.events});

  @override
  List<Object> get props => [events];

  @override
  String toString() => 'EventsLoadedSuccess {event:$events}';
}

class EventsLoadedFailure extends EventsState {
  final String error;

  const EventsLoadedFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EventsLoadedFailure {error:$error}';
}
