import 'package:meta/meta.dart';

import 'api_client_rest.dart';
import '../models/access_model.dart';
import '../models/ticket_access_model.dart';

class AccessControlClient{
  final ApiClient apiClient;

  AccessControlClient({@required this.apiClient});

  Future<List<AccessModel>> fetchAllTicketAccesses(Map<String, String> param) async {
    try {
      final response = await apiClient.get('$accessControlUrl', param);
      final _list = response as List;
      return _list
          ?.map((e) => AccessModel.fromJson(e))
          ?.toList(growable: false);
    } catch (e) {
      throw e;
    }
  }

  Future<TicketAccessModel> registerAccess(Map<String, String> body) async {
    try {
      final response = await apiClient.post('$accessControlUrl', body);
      return TicketAccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<TicketAccessModel> lockAccess(Map<String, String> body) async {
    try {
      final response = await apiClient.post("$accessControlUrl", body);
      return TicketAccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<TicketAccessModel> unlockAccess(Map<String, String> body) async {
    try {
      final response = await apiClient.post('$accessControlUrl', body);
      return TicketAccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}