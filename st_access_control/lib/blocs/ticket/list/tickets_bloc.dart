import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:st_common/st_ac.dart';
import 'package:meta/meta.dart';

import '../filter/ticket_filter_model.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketRepository ticketRepository;

  TicketsBloc({@required this.ticketRepository}) : super(TicketsInitial());

  @override
  Stream<TicketsState> mapEventToState(TicketsEvent event) async* {
    if(event is TicketsStartedLoad){
      yield* _mapLoadAll(event.filter);
    } else if(event is TicketsRefresh){
      yield* _mapRefresh(event.filter);
    }
  }

  Stream<TicketsState> _mapLoadAll(TicketFilterModel filter) async* {
    yield TicketsLoadInProgress();
    try {
      List<TicketModel> result;
      if (filter.search != null && filter.search.isNotEmpty) {
        result = await ticketRepository.fetchAllTickets(_filter(filter));
      }
      yield TicketsLoadedSuccess(tickets: result);
    } catch (e) {
      yield e is ErrorModel
          ? TicketsLoadedFailure(error: e.getMessage())
          : TicketsLoadedFailure(error: e.toString());
    }
  }

  Stream<TicketsState> _mapRefresh(TicketFilterModel filter) async* {
    yield TicketsLoadInProgress();
    try {
      List<TicketModel> result;
      if (filter.search != null && filter.search.isNotEmpty) {
        result = await ticketRepository.refreshTickets(_filter(filter));
      }
      yield TicketsLoadedSuccess(tickets: result);
    } catch (e) {
      yield e is ErrorModel
          ? TicketsLoadedFailure(error: e.getMessage())
          : TicketsLoadedFailure(error: e.toString());
    }
  }

  Map<String, String> _filter(TicketFilterModel filter) {
    Map<String, String> _filter = {};

    if (filter.sort != null) {
      _filter["sort"] = '${filter.sort.varName},${filter.sortType?.varName ?? 'asc'}';
    }

    if (filter.eventId != null) {
      _filter["eventId"] = filter.eventId;
    }

    if (filter.searchBy != null && filter.search != null && filter.search.isNotEmpty) {
      switch (filter.searchBy){
        case TicketSearchByEnum.ACCESS_CODE:
          _filter["accessCode"] = filter.search;
          break;
        case TicketSearchByEnum.TICKET_OWNER:
          _filter["search"] = filter.search;
          break;
      }
    }

    return _filter.isEmpty ? null : _filter;
  }
}
