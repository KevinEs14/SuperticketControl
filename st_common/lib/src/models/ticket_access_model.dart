import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'ticket_access_state_model.dart';
import 'access_model.dart';
import 'user_model.dart';

class TicketAccessModel extends Equatable {
  final String id;
  final String accessCode;
  final int accessQuantity;
  final TicketAccessStateModel state;
  final UserModel owner;
  final List<AccessModel> accesses;
  final String note;

  TicketAccessModel({
    @required this.id,
    @required this.accessCode,
    @required this.accessQuantity,
    @required this.state,
    @required this.owner,
    @required this.accesses,
    @required this.note,
  });

  @override
  List<Object> get props => [id, accessCode, accessQuantity, state, owner, accesses, note];

  @override
  String toString() => 'TicketAccessModel {$id, $accessCode, $accessQuantity, $state, $owner, $accesses, $note}';

  TicketAccessModel copyWith({
    String id,
    String accessCode,
    int accessQuantity,
    TicketAccessStateModel state,
    UserModel owner,
    List<AccessModel> accesses,
    String note,
  }) {
    return TicketAccessModel(
      id: id ?? this.id,
      accessCode: accessCode ?? this.accessCode,
      accessQuantity: accessQuantity ?? this.accessQuantity,
      state: state ?? this.state,
      owner: owner ?? this.owner,
      accesses: accesses ?? this.accesses,
      note: note ?? this.note,
    );
  }
  
  static TicketAccessModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    final _list = json['accesses'] as List;
    // final _list = [{'id': '123', 'date': '2020-12-02T21:00:00-04:00', 'user':{'firstname':'Camilo'}},
    //   {'id': '123', 'date': '2020-12-02T21:00:00-04:00', 'user':{'firstname':'Camilo'}}];

    final _name = json['name'];
    final _email = json['email'];
    final _ci = json['ci'];
    Map<String, String> _owner;
    if (_name != null || _ci != null || _email != null) {
      _owner = {
        'firstName': _name,
        'email': _email,
        'documentNumber': _ci
      };
    }
    
    return TicketAccessModel(
      id: json['id'],
      accessCode: json['code'],
      accessQuantity: json['accessQuantity'],
      // accessQuantity: 4,
      state: TicketAccessStateModel.fromJson(json['accessControlState'] ?? {}),
      // state: TicketAccessStateModel(key: 'LOCKED', value: 'Bloqueado'),
      owner: UserModel.fromJson(_owner ?? {}),
      accesses: _list?.map((e) => AccessModel.fromJson(e))?.toList(growable: false),
      note: json['note'],
    );
  }
  
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'ticketCode': this.accessCode,
        'quantity': this.accessQuantity,
        'state': this.state.toJson(),
        'ownerName': this.owner.toJson(),
        'accesses': this.accesses?.map((e) => e.toJson())?.toList(growable: false),
        'note': this.note,
      };
}