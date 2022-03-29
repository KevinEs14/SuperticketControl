part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  final TicketFilterModel filter;

  const TicketsEvent(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'TicketsEvent {filter:$filter}';
}

class TicketsStartedLoad extends TicketsEvent {
  const TicketsStartedLoad(TicketFilterModel filter) : super(filter);
}

class TicketsRefresh extends TicketsEvent {
  const TicketsRefresh(TicketFilterModel filter) : super(filter);
}
