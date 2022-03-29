import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SeatModel extends Equatable {
  final String id;
  final String alias;

  SeatModel({
    @required this.id,
    @required this.alias,
  });

  @override
  List<Object> get props => [id, alias];

  @override
  String toString() => 'SeatModel {id:$id, alias:$alias}';

  SeatModel copyWith({
    String id,
    String alias,
  }) {
    return SeatModel(
      id: id ?? this.id,
      alias: alias ?? this.alias,
    );
  }

  static SeatModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return SeatModel(
      id: json['id'],
      alias: json['alias'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'alias': this.alias,
      };
}