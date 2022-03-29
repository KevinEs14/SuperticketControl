import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'venue_model.dart';

class EventModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageHomeUrl;
  final String imageDetailUrl;
  final String doorOpeningDate;
  final String eventStartDate;
  final String eventEndDate;
  final VenueModel venue;
  final String lastModifiedDate; //for refresh screen

  EventModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageHomeUrl,
    @required this.imageDetailUrl,
    @required this.doorOpeningDate,
    @required this.eventStartDate,
    @required this.eventEndDate,
    @required this.venue,
    @required this.lastModifiedDate,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        imageHomeUrl,
        imageDetailUrl,
        doorOpeningDate,
        eventStartDate,
        eventEndDate,
        venue,
        lastModifiedDate,
      ];

  @override
  String toString() => 'EventModel {$id, $name, $description, $imageHomeUrl, $imageDetailUrl, $doorOpeningDate, $eventStartDate, $eventEndDate, $venue, $lastModifiedDate}';

  EventModel copyWith({
    String id,
    String name,
    String description,
    String imageHomeUrl,
    String imageDetailUrl,
    String doorOpeningDate,
    String eventStartDate,
    String eventEndDate,
    VenueModel venue,
    String lastModifiedDate,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageHomeUrl: imageHomeUrl ?? this.imageHomeUrl,
      imageDetailUrl: imageDetailUrl ?? this.imageDetailUrl,
      doorOpeningDate: doorOpeningDate ?? this.doorOpeningDate,
      eventStartDate: eventStartDate ?? this.eventStartDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      venue: venue ?? this.venue,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate
    );
  }

  static EventModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;

    return EventModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageHomeUrl: json['homeImage'],
      imageDetailUrl: json['detailImage'],
      doorOpeningDate: json['doorOpening'],
      eventStartDate: json['dateTime'],
      eventEndDate: json['visibilityEnds'],
      venue: VenueModel.fromJson(json['venue'] ?? {}),
      lastModifiedDate: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'description': this.description,
        'homeImage': this.imageHomeUrl,
        'imageDetailUrl': this.imageDetailUrl,
        'doorOpeningDate': this.doorOpeningDate,
        'eventStartDate': this.eventStartDate,
        'eventEndDate': this.eventEndDate,
        'venue': this.venue.toJson(),
      };
}