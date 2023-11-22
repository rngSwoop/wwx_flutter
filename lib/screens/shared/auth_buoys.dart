class AuthBuoys {
  int buoyID;
  String name;
  String password;
  String authLevel;
  bool updated;
  String MAC;
  int locationID;
  List<LocationDataPoint> locationData; // List of date and locationLatLong and locationName data points

  AuthBuoys({
    required this.buoyID,
    required this.name,
    required this.password,
    required this.authLevel,
    required this.updated,
    required this.MAC,
    required this.locationID,
    required this.locationData, // Initialize with an empty list
  });

  // Constructor to convert json data to AuthBuoy objects
  factory AuthBuoys.fromJson(Map<String, dynamic> json) {
    // Extract date and location data from the JSON
    List<dynamic> jsonData = json['locationData'] as List;
    List<LocationDataPoint> dataPoints = jsonData.map((map) => LocationDataPoint.fromJson(map)).toList();

    return AuthBuoys(
      buoyID: json['id'] as int,
      name: json['name'] as String,
      password: json['password'] as String,
      authLevel: json['authLevel'] as String,
      updated: json['updated'] as bool,
      MAC: json['MAC'] as String,
      locationID: json['locationId'] as int,
      locationData: dataPoints,
    );
  }
}

class LocationDataPoint {
  String date;
  String locationLatLong;
  String locationName;

  LocationDataPoint({
    required this.date,
    required this.locationLatLong,
    required this.locationName,
  });

  // Constructor to convert JSON data to LocationDataPoint objects
  factory LocationDataPoint.fromJson(Map<String, dynamic> json) {
    return LocationDataPoint(
      date: json['date'] as String,
      locationLatLong: json['locationLatLong'] as String,
      locationName: json['locationName'] as String,
    );
  }
}