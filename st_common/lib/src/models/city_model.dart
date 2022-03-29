import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../helpers/enum_helper.dart';

enum CityEnum { BN, CB, CH, LP, OR, PN, PT, SC, TJ}

class CityModel extends Equatable {
  final String key;
  final String value;

  CityModel({
    @required this.key,
    @required this.value,
  });

  @override
  List<Object> get props => [key, value];

  CityEnum get toEnum => stringToEnum<CityEnum>(CityEnum.values, this.key);

  @override
  String toString() => 'CityModel {key:$key, value:$value}';

  CityModel copyWith({
    String key,
    String value,
  }) {
    return CityModel(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  static CityModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return CityModel(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': this.key,
        'value': this.value,
      };
}