part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class EventsLoadAll extends EventsEvent {}

class EventsRefresh extends EventsEvent {}
