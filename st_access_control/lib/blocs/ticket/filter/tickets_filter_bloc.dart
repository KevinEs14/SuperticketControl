import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';
import 'ticket_filter_model.dart';
import '../list/tickets_bloc.dart';

part 'tickets_filter_event.dart';
part 'tickets_filter_state.dart';

class TicketsFilterBloc extends Bloc<TicketsFilterEvent, TicketsFilterState> {
  final TicketsBloc ticketsBloc;

  TicketsFilterBloc({
    @required this.ticketsBloc,
  }) : super(TicketsFilterState.initial());

  @override
  Stream<TicketsFilterState> mapEventToState(TicketsFilterEvent event) async* {
    if (event is TicketsFilterSearch) {
      if (event.search != null) {
        yield* _mapUpdateData(event.search);
      }
    } else if (event is TicketsFilter){
      yield state.copyWith(filter: event.filter);
      ticketsBloc.add(TicketsStartedLoad(event.filter));
    }
  }

  Stream<TicketsFilterState> _mapUpdateData(String search) async* {
    TicketFilterModel _old = state.filter;
    _old = _old.copyWith(search: search);
    yield state.copyWith(filter: _old);
    ticketsBloc.add(TicketsStartedLoad(_old));
  }
}
