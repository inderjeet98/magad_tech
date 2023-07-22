// To parse this JSON data, do
//
//     final saveUser = saveUserFromJson(jsonString);

import 'dart:convert';

SaveUser saveUserFromJson(String str) => SaveUser.fromJson(json.decode(str));

String saveUserToJson(SaveUser data) => json.encode(data.toJson());

class SaveUser {
  String name;
  String email;
  String phone;
  Location location;

  SaveUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory SaveUser.fromJson(Map<String, dynamic> json) => SaveUser(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "location": location.toJson(),
      };
}

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
