part of 'tickets_filter_bloc.dart';

abstract class TicketsFilterEvent extends Equatable {
  const TicketsFilterEvent();

  @override
  List<Object> get props => [];
}

class TicketsFilterSearch extends TicketsFilterEvent{
  final String search;

  const TicketsFilterSearch({@required this.search});

  @override
  List<Object> get props => [search];

  @override
  String toString() => 'TicketsFilterSearch {search:$search}';
}

class TicketsFilter extends TicketsFilterEvent{
  final TicketFilterModel filter;

  const TicketsFilter({@required this.filter});

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'TicketsFilter {filter:$filter}';
}