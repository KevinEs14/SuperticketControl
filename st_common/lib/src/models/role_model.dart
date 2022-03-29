import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../helpers/enum_helper.dart';

enum Role {
  ROLE_ADMIN, //Administrador de sitio
  ROLE_EXECUTIVE_ST, //Ejecutivos de SuperTicket
  ROLE_ADMIN_EVENT, //Administrador de Eventos
  ROLE_ADMIN_BUSSINES, //Administrador de Empresa
  ROLE_ADMIN_PS, //Ejecutivos de SuperTicket
  ROLE_PS_PHYSYCAL, //Administrador de Eventos
  ROLE_PS_MOBILE, //Administrador de Empresa
  ROLE_PS_CALL_CENTER, //Administrador de Puntos de Venta
  ROLE_RELATION, //Punto de Venta en Físico
  ROLE_BANK_REFUND, //Punto de Venta Móvil
  ROLE_HOME_DELIVERY, //Punto de Venta Call Center
  ROLE_ADMIN_ACCOUNTING, //Relacionadores
  ROLE_ADMIN_ADVERTISING, //Bancos y Reembolsos
  ROLE_PROMOTER, //Entregas a Domicilio
  ROLE_ADMIN_INCOME_CONTROL, //Administrador Contable
  ROLE_CONTROL, //Administrador Publicitario
  ROLE_PRODUCT_EXCHANGE, //Promotor
  ROLE_CONSUMER_OPERATOR, //Administrador de Control de Ingreso
  ROLE_USER, //Control
}

class RoleModel extends Equatable {
  final String id;
  final String name;

  RoleModel({
    @required this.id,
    @required this.name,
  });

  @override
  List<Object> get props => [id, name];

  @override
  String toString() => 'RoleModel {id:$id, name:$name}';

  Role get toEnum => stringToEnum<Role>(Role.values, this.id);

  RoleModel copyWith({
    int id,
    String name,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  static RoleModel fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) return null;

    return RoleModel(
      id: json['name'],
      name: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': this.id,
        'description': this.name,
      };
}
