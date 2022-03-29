import 'package:meta/meta.dart';

import 'api_client_rest.dart';
import '../models/ticket_model.dart';
import '../models/ticket_book_accessed_model.dart';

class TicketClient{
  final ApiClient apiClient;

  TicketClient({@required this.apiClient});

  Future<List<TicketModel>> fetchAllTickets(Map<String, String> param) async {
    try {
      final response = await apiClient.get('$accessControlUrl', param);
      final _list = response as List;
      return _list
          ?.map((e) => TicketModel.fromJson(e))
          ?.toList(growable: false);
    } catch (e) {
      throw e;
    }
  }

  Future<List<TicketBookAccessedModel>> readTotalTickets(String eventId) async {
    final _param = {'event-id': eventId};
    try {
      final response = await apiClient.get("$accessTicketBookUrl",_param);
      final _list = response as List;
      return _list
          ?.map((e) => TicketBookAccessedModel.fromJson(e))
          ?.toList(growable: false);
    } catch (e) {
      throw e;
    }
  }

  Future<TicketModel> editTicket(TicketModel ticket) async {
    try {
      final response = await apiClient.put('$accessControlUrl', ticket.toJson());
      return TicketModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}