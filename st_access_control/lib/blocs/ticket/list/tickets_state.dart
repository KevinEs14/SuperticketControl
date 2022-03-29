part of 'tickets_bloc.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object> get props => [];
}

class TicketsInitial extends TicketsState {}

class TicketsLoadInProgress extends TicketsState {}

class TicketsLoadedSuccess extends TicketsState {
  final List<TicketModel> tickets;

  const TicketsLoadedSuccess({@required this.tickets});

  @override
  List<Object> get props => [tickets];

  @override
  String toString() => 'TicketsLoadedSuccess {tickets:$tickets}';
}

class TicketsLoadedFailure extends TicketsState {
  final String error;

  const TicketsLoadedFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TicketsLoadedFailure {error:$error}';
}