part of 'tickets_filter_bloc.dart';

class TicketsFilterState extends Equatable {
  final TicketFilterModel filter;
  final MyFormStatus status;

  const TicketsFilterState({
    @required this.filter,
    @required this.status,
  });

  @override
  List<Object> get props => [filter, status];

  @override
  String toString() => 'TicketsFilterState {$filter, $status}';

  TicketsFilterState copyWith({
    TicketFilterModel filter,
    MyFormStatus status,
  }) {
    return TicketsFilterState(
      filter: filter ?? this.filter,
      status: status ?? this.status,
    );
  }

  bool get disabledWidgets => this.status == MyFormStatus.IN_PROGRESS;

  static TicketsFilterState initial() {
    return TicketsFilterState(
      filter: TicketFilterModel.createNew(),
      status: MyFormStatus.INITIAL,
    );
  }
}