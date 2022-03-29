import 'package:meta/meta.dart';

import 'api_client_rest.dart';
import '../models/event_model.dart';

class EventClient{
  final ApiClient apiClient;

  EventClient({@required this.apiClient});

  Future<List<EventModel>> fetchAllEventsForAccessControl() async {
    try {
      final response = await apiClient.get('$accessControlEventUrl');
      final _list = response as List;
      return _list
          ?.map((e) => EventModel.fromJson(e))
          ?.toList(growable: false);
    } catch (e) {
      throw e;
    }
  }

  Future<EventModel> readEvent(String eventId) async {
    try {
      final response = await apiClient.get("$accessControlEventUrl/$eventId");
      return EventModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<EventModel> addEvent(EventModel event) async {
    try {
      final response = await apiClient.post('$accessControlEventUrl', event.toJson());
      return EventModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<EventModel> editEvent(EventModel event) async {
    try {
      final response = await apiClient.put('$accessControlEventUrl', event.toJson());
      return EventModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await apiClient.delete("$accessControlEventUrl/$eventId");
      return;
    } catch (e) {
      throw e;
    }
  }
}