import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:st_common/st_ac.dart';
import 'package:meta/meta.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventACRepository eventACRepository;

  EventsBloc({@required this.eventACRepository}) : super(EventsInitial());

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if(event is EventsLoadAll){
      yield* _mapLoadAll();
    } else if(event is EventsRefresh){
      yield* _mapRefresh();
    }
  }

  Stream<EventsState> _mapLoadAll() async* {
    yield EventsLoadInProgress();
    try {
      final result = await eventACRepository.fetchAllEvents();
      yield EventsLoadedSuccess(events: result);
    } catch (e) {
      yield e is ErrorModel
          ? EventsLoadedFailure(error: e.getMessage())
          : EventsLoadedFailure(error: e.toString());
    }
  }

  Stream<EventsState> _mapRefresh() async* {
    yield EventsLoadInProgress();
    try {
      final result = await eventACRepository.refreshEvents();
      yield EventsLoadedSuccess(events: result);
    } catch (e) {
      yield e is ErrorModel
          ? EventsLoadedFailure(error: e.getMessage())
          : EventsLoadedFailure(error: e.toString());
    }
  }
}
