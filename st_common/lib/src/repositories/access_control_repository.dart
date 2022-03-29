import 'package:meta/meta.dart';

import '../models/ticket_access_model.dart';
import '../models/access_model.dart';
import '../client/access_control_client.dart';

class AccessControlRepository{
  final AccessControlClient accessControlClient;

  AccessControlRepository({@required this.accessControlClient});

  Future<List<AccessModel>> fetchAllTicketAccesses(Map<String, String> filter) async {
    Map<String, String> _param;
    if (filter != null) {
      _param.addAll(filter);
    }
    return await accessControlClient.fetchAllTicketAccesses(_param);
  }

  Future<TicketAccessModel> registerAccess(String ticketAccessId, int qty, String note) async {
    Map<String, String> body = {
      'id': ticketAccessId,
      'quantity': '$qty',
      'note': note != null && note.isNotEmpty ? note : null,
    };
    return await accessControlClient.registerAccess(body);
  }

  Future<TicketAccessModel> lockAccess(String ticketAccessId, String note) async {
    Map<String, String> body = {
      'id': ticketAccessId,
      'note': note,
    };
    return await accessControlClient.lockAccess(body);
  }

  Future<TicketAccessModel> unlockAccess(String ticketAccessId,  String note) async {
    Map<String, String> body = {
      'id': ticketAccessId,
      'note': note,
    };
    return await accessControlClient.unlockAccess(body);
  }
}