import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'seat_model.dart';
import 'sector_model.dart';
import 'ticket_access_model.dart';
import '../helpers/enum_helper.dart';
import 'ticket_book_model.dart';

enum TicketStatusEnum {AVAILABLE, RESERVATION, AWARD, LOCKED, CANCELLED}

extension TicketStatusExtension on TicketStatusEnum{
  String get name{
    switch(this){
      case TicketStatusEnum.AVAILABLE:
        return 'Disponible';
      case TicketStatusEnum.RESERVATION:
        return 'Reservado';
      case TicketStatusEnum.AWARD:
        return 'Adjudicado';
      case TicketStatusEnum.LOCKED:
        return 'Bloqueado';
      case TicketStatusEnum.CANCELLED:
        return 'Anulado';
      default:
        return null;
    }
  }
}

class TicketModel extends Equatable {
  final String id;
  final String code;
  final TicketStatusEnum status;
  final TicketBookModel ticketBook;
  final TicketAccessModel access;
  final SectorModel sector;
  final SeatModel seat;

  TicketModel({
    @required this.id,
    @required this.code,
    @required this.status,
    @required this.ticketBook,
    @required this.access,
    @required this.sector,
    @required this.seat,
  });

  @override
  List<Object> get props => [id, code, status, ticketBook, access, sector, seat];

  @override
  String toString() => 'TicketModel {$id, $code, $status, $ticketBook, $access, $sector, $seat}';

  TicketModel copyWith({
    String id,
    String code,
    TicketStatusEnum status,
    TicketBookModel ticketBook,
    TicketAccessModel access,
    SectorModel sector,
    SeatModel seat,
  }) {
    return TicketModel(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      ticketBook: ticketBook ?? this.ticketBook,
      access: access ?? this.access,
      sector: sector ?? this.sector,
      seat: seat ?? this.seat,
    );
  }
  
  static TicketModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    final Map<String, dynamic> _ticket = json['ticket'];

    return TicketModel(
      id: _ticket['id'],
      code: _ticket['code'],
      status: stringToEnum<TicketStatusEnum>(TicketStatusEnum.values, _ticket['status']),
      ticketBook: TicketBookModel.fromJson(_ticket['ticketBook'] ?? {}),
      access: TicketAccessModel.fromJson(json['accessControl'] ?? {}),
      sector: SectorModel.fromJson(_ticket['sector'] ?? {}),
      seat: SeatModel.fromJson(_ticket['seat' ?? {}])
    );
  }
  
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'code': this.code,
        'status': this.status.toString().split('.').last,
        'ticketBook': this.ticketBook.toJson(),
        'accessControl': this.access.toJson(),
        'sector': this.sector.toJson(),
        'seat': this.seat.toJson(),
      };
}