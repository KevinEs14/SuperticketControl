import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../helpers/enum_helper.dart';

enum TicketTypeEnum {TICKET_WEB_ONLY, HARD_TICKET, ACCESS_ONLY, CREDENTIAL, BRACELET}

extension ticketTypeExtension on TicketTypeEnum{
  String get name{
    switch(this){
      case TicketTypeEnum.TICKET_WEB_ONLY:
        return 'Web Ticket';
      case TicketTypeEnum.HARD_TICKET:
        return 'Hard Ticket';
      case TicketTypeEnum.ACCESS_ONLY:
        return 'Solo acceso';
      case TicketTypeEnum.CREDENTIAL:
        return 'Credencial';
      case TicketTypeEnum.BRACELET:
        return 'Brasalete';
      default:
        return null;
    }
  }
}

class TicketBookModel extends Equatable {
  final String id;
  final String name;
  final String color;
  final int quantity;
  final int accessQuantity;
  final String image;
  final TicketTypeEnum type;

  TicketBookModel({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.quantity,
    @required this.accessQuantity,
    @required this.image,
    @required this.type,
  });

  @override
  List<Object> get props => [id, name, color, quantity, accessQuantity, image, type];

  @override
  String toString() => 'TicketBookModel {$id, $name, $color, $quantity, $accessQuantity, $image, $type}';

  TicketBookModel copyWith({
    String id,
    String name,
    String color,
    int quantity,
    int accessQuantity,
    String image,
    TicketTypeEnum type,
  }) {
    return TicketBookModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      accessQuantity: accessQuantity ?? this.accessQuantity,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }
  
  static TicketBookModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return TicketBookModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      quantity: json['quantity'],
      accessQuantity: json['accessQuantity'],
      image: json['hardTicketImage'],
      type: stringToEnum<TicketTypeEnum>(TicketTypeEnum.values, json['type'])
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'color': this.color,
        'quantity': this.quantity,
        'accessQuantity': this.accessQuantity,
        'hardTicketImage': this.image,
        'type': this.type.toString()?.split('.')?.last,
      };
}