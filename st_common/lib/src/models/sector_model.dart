import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../helpers/enum_helper.dart';

enum SectorTypeEnum {SEATING, STANDING}

extension sectorTypeExtension on SectorTypeEnum{
  String get name{
    switch(this){
      case SectorTypeEnum.SEATING:
        return 'Sentado';
      case SectorTypeEnum.STANDING:
        return 'Parado';
      default:
        return null;
    }
  }
}

class SectorModel extends Equatable {
  final String id;
  final String name;
  final SectorTypeEnum type;

  SectorModel({
    @required this.id,
    @required this.name,
    @required this.type,
  });

  @override
  List<Object> get props => [id, name, type];

  @override
  String toString() => 'SectorModel {id:$id, $name, $type}';

  SectorModel copyWith({
    String id,
    String name,
    SectorTypeEnum type,
  }) {
    return SectorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  static SectorModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return SectorModel(
      id: json['id'],
      name: json['name'],
      type: stringToEnum<SectorTypeEnum>(SectorTypeEnum.values, json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'type': this.type?.toString()?.split('.')?.last,
      };
}