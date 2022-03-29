import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:st_common/st_ac.dart';
import 'package:meta/meta.dart';

part 'event_crud_event.dart';
part 'event_crud_state.dart';

class EventCrudBloc extends Bloc<EventCrudEvent, EventCrudState> {
  final TicketRepository ticketRepository;

  EventCrudBloc({
    @required this.ticketRepository
  }) : super(EventCrudInitial());

  @override
  Stream<EventCrudState> mapEventToState(EventCrudEvent event) async* {
    if (event is EventCrudInitialize) {
      yield EventCrudInitial();
    } else if (event is EventCrudReadTotalTickets){
      yield* _mapReadTotalTickets(event.eventId);
    } else if (event is EventCrudRefresh) {
      if (state.eventId != null) {
        yield* _mapRefreshTotalTickets();
      }
    }
  }

  Stream<EventCrudState> _mapReadTotalTickets(String eventId) async* {
    yield EventCrudInProgress(eventId);
    try {
      final result = await ticketRepository.readTotalTickets(eventId);
      int _totalTickets = 0;
      int _totalTicketsRead = 0;
      if(result != null && result.isNotEmpty){
        result.forEach((element) {
          _totalTickets = _totalTickets + element?.ticketBook?.quantity ?? 0;
          _totalTicketsRead = _totalTicketsRead + element?.totalAccessesRead ?? 0;
        });
      }
      yield EventCrudSuccess(
        eventId: eventId,
        ticketsAccesses: result,
        totalTickets: _totalTickets,
        totalTicketsRead: _totalTicketsRead,
      );
    } catch (e) {
      yield e is ErrorModel
          ? EventCrudFailure(error: e.getMessage(), eventId: eventId)
          : EventCrudFailure(error: e.toString(), eventId: eventId);
    }
  }

  Stream<EventCrudState> _mapRefreshTotalTickets() async* {
    try {
      final result = await ticketRepository.readTotalTickets(state.eventId);
      int _totalTickets = 0;
      int _totalTicketsRead = 0;
      if(result != null && result.isNotEmpty){
        result.forEach((element) {
          _totalTickets = _totalTickets + element?.ticketBook?.quantity ?? 0;
          _totalTicketsRead = _totalTicketsRead + element?.totalAccessesRead ?? 0;
        });
      }
      yield EventCrudSuccess(
        eventId: state.eventId,
        ticketsAccesses: result,
        totalTickets: _totalTickets,
        totalTicketsRead: _totalTicketsRead,
      );
    } catch (e) {
      yield e is ErrorModel
          ? EventCrudFailure(error: e.getMessage(), eventId: state.eventId)
          : EventCrudFailure(error: e.toString(), eventId: state.eventId);
    }
  }
}
