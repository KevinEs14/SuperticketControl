import 'package:meta/meta.dart';

import '../models/ticket_model.dart';
import '../client/ticket_client.dart';
import '../models/ticket_book_accessed_model.dart';

class TicketRepository{
  final TicketClient ticketClient;

  TicketRepository({@required this.ticketClient});

  Future<List<TicketModel>> fetchAllTickets(Map<String, String> filter) async {
    Map<String, String> _param;
    if (filter != null) {
      _param = {};
      _param.addAll(filter);
    }
    return await ticketClient.fetchAllTickets(_param);
  }

  Future<List<TicketModel>> refreshTickets(Map<String, String> filter) async {
    return await ticketClient.fetchAllTickets(filter);
  }

  Future<List<TicketBookAccessedModel>> readTotalTickets(String eventId) async {
    return await ticketClient.readTotalTickets(eventId);
  }

  Future<TicketModel> editTicket(TicketModel ticket) async {
    return await ticketClient.editTicket(ticket);
  }
}