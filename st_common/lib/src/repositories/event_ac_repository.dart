import 'package:meta/meta.dart';

import '../models/event_model.dart';
import '../client/event_client.dart';

class EventACRepository{
  final EventClient eventClient;

  EventACRepository({@required this.eventClient});

  List<EventModel> _eventsCache;

  Future<List<EventModel>> refreshEvents() async {
    try {
      final _result = await eventClient.fetchAllEventsForAccessControl();
      _eventsCache = _result;
      return _eventsCache;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<EventModel>> fetchAllEvents() async {
    if(_eventsCache != null) return _eventsCache;

    try {
      final _result = await eventClient.fetchAllEventsForAccessControl();
      _eventsCache = _result;
      return _eventsCache;
    } catch (e) {
      throw (e);
    }
  }

  Future<EventModel> readEvent(String eventId) async {
    if(_eventsCache != null)
      return _eventsCache.firstWhere((element) => element.id == eventId, orElse: () => null);

    return null;
  }

  Future<EventModel> editEvent(EventModel event) async {
    try {
      final _result = await eventClient.editEvent(event);
      for(int i=0; i<_eventsCache.length; i++) {
        if(_eventsCache[i].id == event.id){
          _eventsCache[i] = _result;
          break;
        }
      }
      return _result;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await eventClient.deleteEvent(eventId);
      for(int i=0; i<_eventsCache.length; i++) {
        if(_eventsCache[i].id == eventId){
          _eventsCache.removeAt(i);
          break;
        }
      }
      return;
    } catch (e) {
      throw e;
    }
  }
}