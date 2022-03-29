import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'user_model.dart';

class AccessModel extends Equatable {
  final String id;
  final String date;
  final UserModel attendedBy;

  AccessModel({
    @required this.id,
    @required this.date,
    @required this.attendedBy,
  });

  @override
  List<Object> get props => [id, date, attendedBy];

  @override
  String toString() => 'AccessModel {id:$id, $date, $attendedBy}';

  AccessModel copyWith({
    String id,
    String date,
    UserModel employee,
  }) {
    return AccessModel(
      id: id ?? this.id,
      date: date ?? this.date,
      attendedBy: employee ?? this.attendedBy,
    );
  }
  
  static AccessModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;
    
    return AccessModel(
      id: json['id'],
      date: json['accessDate'],
      attendedBy: UserModel.fromJson(json['user'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'accessDate': this.date,
        'user': this.attendedBy.toJson(),
      };
}