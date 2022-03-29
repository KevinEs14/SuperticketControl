import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../helpers/enum_helper.dart';

enum TicketAccessStateEnum {ENABLED, LOCKED}

class TicketAccessStateModel extends Equatable {
  final String key;
  final String value;

  TicketAccessStateModel({
    @required this.key,
    @required this.value,
  });

  @override
  List<Object> get props => [key, value];

  @override
  String toString() => 'TicketAccessStateModel {key:$key, value:$value}';

  TicketAccessStateEnum get toEnum => stringToEnum<TicketAccessStateEnum>(TicketAccessStateEnum.values, key);

  TicketAccessStateModel copyWith({
    String key,
    String value,
  }) {
    return TicketAccessStateModel(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }
  
  static TicketAccessStateModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;
    
    return TicketAccessStateModel(
      key: json['key'],
      value: json['value'],
    );
  }
  
  Map<String, dynamic> toJson() => {
        'key': this.key,
        'value': this.value,
      };
}