import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'city_model.dart';

class VenueModel extends Equatable {
  final String id;
  final String name;
  final String country;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final CityModel city;

  VenueModel({
    @required this.id,
    @required this.name,
    @required this.country,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.phoneNumber,
    @required this.city,
  });

  @override
  List<Object> get props => [id, name, country, address, latitude, longitude, phoneNumber, city];

  @override
  String toString() => 'VenueModel {$id, $name, $country, $address, $latitude, $longitude, $phoneNumber, $city}';

  VenueModel copyWith({
    String id,
    String name,
    String country,
    String address,
    double latitude,
    double longitude,
    String phoneNumber,
    CityModel city,
  }) {
    return VenueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
    );
  }
  
  static VenueModel fromJson(Map<String, dynamic> json){
    if (json == null || json.isEmpty) return null;
    
    return VenueModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phoneNumber: json['phoneNumber'],
      city: CityModel.fromJson(json['city'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'country': this.country,
        'address': this.address,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'phoneNumber': this.phoneNumber,
        'city': this.city.toJson(),
      };
}