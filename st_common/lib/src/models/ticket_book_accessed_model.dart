import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'ticket_book_model.dart';

class TicketBookAccessedModel extends Equatable {
  final TicketBookModel ticketBook;
  final int totalAccessesRead;

  TicketBookAccessedModel({
    @required this.ticketBook,
    @required this.totalAccessesRead,
  });

  @override
  List<Object> get props => [ticketBook, totalAccessesRead];

  @override
  String toString() => 'TicketBookAccessedModel {ticketBook:$ticketBook, totalAccessesRead:$totalAccessesRead}';

  TicketBookAccessedModel copyWith({
    TicketBookModel ticketBook,
    int totalAccessesRead,
  }) {
    return TicketBookAccessedModel(
      ticketBook: ticketBook ?? this.ticketBook,
      totalAccessesRead: totalAccessesRead ?? this.totalAccessesRead,
    );
  }

  static TicketBookAccessedModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return TicketBookAccessedModel(
      ticketBook: TicketBookModel.fromJson(json['ticketBookResponse'] ?? {}),
      totalAccessesRead: json['totalAccessesRead'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ticketBook': this.ticketBook,
        'totalAccessesRead': this.totalAccessesRead,
      };
}