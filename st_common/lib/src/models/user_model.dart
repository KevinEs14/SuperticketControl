import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'role_model.dart';
import '../helpers/enum_helper.dart';

class UserModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String documentNumber;
  final String imageUrl;
  final List<Role> roles;
  final String email;
  final String userName;
  final bool activated;
  final String lastModifiedDate;

  UserModel({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.documentNumber,
    @required this.imageUrl,
    @required this.roles,
    @required this.email,
    @required this.userName,
    @required this.activated,
    @required this.lastModifiedDate,
  });

  @override
  List<Object> get props =>
      [id, firstName, lastName, documentNumber, imageUrl, roles, email, userName, activated, lastModifiedDate];

  @override
  String toString() =>
      'UserModel {id:$id, $firstName, $lastName, $documentNumber, $imageUrl, $roles, $email, $userName, $activated, $lastModifiedDate}';

  UserModel copyWith({
    int id,
    String firstName,
    String lastName,
    String documentNumber,
    String image,
    List<Role> roles,
    String email,
    String userName,
    bool activated,
    String updateAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      documentNumber: documentNumber ?? this.documentNumber,
      imageUrl: image ?? this.imageUrl,
      roles: roles ?? this.roles,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      activated: activated ?? this.activated,
      lastModifiedDate: updateAt ?? this.lastModifiedDate,
    );
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) return null;

    final _roles = json['authorities'] as List;

    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      documentNumber: json['documentNumber'],
      imageUrl: json['imageUrl'],
      roles: _roles?.cast<String>()?.map((e) => stringToEnum<Role>(Role.values, e))?.toList(growable: false),
      email: json['email'],
      userName: json['login'],
      activated: json['activated'],
      lastModifiedDate: json['lastModifiedDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'firstName': this.firstName,
        'lastName': this.lastName,
        'documentNumber': this.documentNumber,
        'imageUrl': this.imageUrl,
        'authorities': this.roles?.map((e) => e.toString().split('.').last)?.toList(growable: false),
        'email': this.email,
        'login': this.userName,
        'activated': this.activated,
        'lastModifiedDate': this.lastModifiedDate,
      };
}
