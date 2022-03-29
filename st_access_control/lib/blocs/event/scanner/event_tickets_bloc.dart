import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:st_common/st_ac.dart';
import 'package:meta/meta.dart';

part 'event_tickets_event.dart';
part 'event_tickets_state.dart';

class EventTicketsBloc extends Bloc<EventTicketsEvent, EventTicketsState> {
  final TicketRepository ticketRepository;
  final AccessControlRepository accessControlRepository;

  EventTicketsBloc({
    @required this.ticketRepository,
    @required this.accessControlRepository
  }) : super(EventTicketsInitial());

  @override
  Stream<EventTicketsState> mapEventToState(EventTicketsEvent event) async* {
    if (event is EventCrudSearchTicket) {
      yield* _mapSearchTicket(event.eventId, event.accessCode);
    }
    else if (event is EventTicketsInit){
      yield EventTicketsInitial();
    }
    else if(event is EventTicketsRegister){
      yield* _registerTicket(event.ticket);
    }
  }

  Stream<EventTicketsState> _mapSearchTicket(String eventId, String accessCode) async* {
    yield EventTicketsLoadInProgress();
    try {
      final _filter = {
        'eventId': eventId,
        'accessCode': accessCode,
      };
      final List<TicketModel> result = await ticketRepository.fetchAllTickets(_filter);
      if(result == null || result.isEmpty){
          yield EventTicketsLoadedFailure(error: "Ticket no encontrado");
      }
      else{
        yield EventTicketsLoadedSuccess(tickets: result, accessCode: accessCode);
      }
    } catch (e) {
      yield e is ErrorModel
          ? EventTicketsLoadedFailure(error: e.getMessage())
          : EventTicketsLoadedFailure(error: e.toString());
    }
  }
  Stream<EventTicketsState> _registerTicket(TicketModel ticket) async* {
    try {
      final qty=ticket.access.accessQuantity-ticket.access.accesses.length;
      if(qty<=0){
           yield EventTicketsLoadedFailure(error: "Ticket sin Accesos disponibles");
      }
      else{
        final result = await accessControlRepository.registerAccess(ticket.access.id, 1, null);
        yield EventTicketsRegisterSuccess(ticket: result);
      }
    } catch (e) {
      yield e is ErrorModel
          ? EventTicketsLoadedFailure(error: e.getMessage())
          : EventTicketsLoadedFailure(error: e.toString());
    }
  }
}
