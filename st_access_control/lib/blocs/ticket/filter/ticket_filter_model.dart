import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';

enum TicketSearchByEnum {ACCESS_CODE, TICKET_OWNER}

class TicketFilterModel extends Equatable {
  final Sort sort;
  final SortType sortType;
  final String search;
  final TicketSearchByEnum searchBy;
  final String eventId;

  TicketFilterModel({
    @required this.sort,
    @required this.sortType,
    @required this.search,
    @required this.searchBy,
    @required this.eventId,
  });

  @override
  List<Object> get props => [sort, sortType, search, searchBy, eventId];

  @override
  String toString() => 'TicketFilterModel {$sort, $sortType, $search, $searchBy, $eventId}';

  TicketFilterModel copyWith({
    Sort sort,
    SortType sortType,
    String search,
    TicketSearchByEnum searchBy,
    String eventId,
  }) {
    return TicketFilterModel(
      sort: sort ?? this.sort,
      sortType: sortType ?? this.sortType,
      search: search ?? this.search,
      searchBy: searchBy ?? this.searchBy,
      eventId: eventId ?? this.eventId,
    );
  }

  static TicketFilterModel createNew() {
    return TicketFilterModel(
      sort: Sort.NAME,
      sortType: SortType.DESC,
      search: null,
      searchBy: null,
      eventId: null,
    );
  }

  static TicketFilterModel searchByTicket(String eventId, [String search]) {
    return TicketFilterModel(
      sort: Sort.NAME,
      sortType: SortType.DESC,
      search: search,
      searchBy: TicketSearchByEnum.ACCESS_CODE,
      eventId: eventId,
    );
  }

  static TicketFilterModel searchByOwner(String eventId) {
    return TicketFilterModel(
      sort: Sort.NAME,
      sortType: SortType.DESC,
      search: null,
      searchBy: TicketSearchByEnum.TICKET_OWNER,
      eventId: eventId,
    );
  }
}