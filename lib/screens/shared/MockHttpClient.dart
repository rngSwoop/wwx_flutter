import 'dart:convert';
import 'package:http/http.dart' as http;

class MockHttpClient {
  // Constructor for the mock client
  MockHttpClient();

  Future<http.Response> get(Uri url) async {
    // Simulate an API response with JSON data
    final jsonResponse = [
      {
        "buoyID": "1234",
        "name": "Buoy 1",
        "password": "password1",
        "authLevel": "user",
        "updated": true,
        "MAC": "00:11:22:33:44:55",
        "locationData": [
          {
            "date": "2023-10-15",
            "locationLatLong": "Latitude: 40.7129, Longitude: -74.0062",
            "locationName": "Lake Whatcom"
          },
          {
            "date": "2023-10-14",
            "locationLatLong": "Latitude: 40.7127, Longitude: -74.0061",
            "locationName": "Gas Works Park"
          },
          {
            "date": "2023-10-13",
            "locationLatLong": "Latitude: 40.7126, Longitude: -74.0062",
            "locationName": "Lake Tahoe"
          },
          {
            "date": "2023-10-12",
            "locationLatLong": "Latitude: 40.7125, Longitude: -74.0063",
            "locationName": "Seaside Park"
          },
          {
            "date": "2023-10-11",
            "locationLatLong": "Latitude: 40.7129, Longitude: -74.0064",
            "locationName": "Harbor View Park"
          },
          {
            "date": "2023-10-10",
            "locationLatLong": "Latitude: 40.7130, Longitude: -74.0065",
            "locationName": "Lake Tahoe"
          },
          {
            "date": "2023-10-9",
            "locationLatLong": "Latitude: 40.7131, Longitude: -74.0066",
            "locationName": "Columbia River"
          },
          {
            "date": "2023-10-8",
            "locationLatLong": "Latitude: 40.7132, Longitude: -74.0067",
            "locationName": "Hood Canal"
          },
          {
            "date": "2023-10-7",
            "locationLatLong": "Latitude: 40.7133, Longitude: -74.0068",
            "locationName": "Boulevard Park"
          },
          {
            "date": "2023-10-6",
            "locationLatLong": "Latitude: 40.7134, Longitude: -74.0069",
            "locationName": "Lake Washington"
          },
          {
            "date": "2023-10-5",
            "locationLatLong": "Latitude: 40.7135, Longitude: -74.0070",
            "locationName": "Snake River"
          },
          {
            "date": "2023-10-4",
            "locationLatLong": "Latitude: 40.7136, Longitude: -74.0071",
            "locationName": "Salish Sea"
          }
        ]
      },
      {
        "buoyID": "12983t",
        "name": "Buoy 2",
        "password": "password2",
        "authLevel": "manager",
        "updated": true,
        "MAC": "A1:B2:C3:D4:E5:F6",
        "locationData": [
          {
            "date": "2023-10-15",
            "locationLatLong": "Latitude: 40.7129, Longitude: -74.0064",
            "locationName": "Harbor View Park"
          },
          {
            "date": "2023-10-14",
            "locationLatLong": "Latitude: 40.7130, Longitude: -74.0065",
            "locationName": "Lake Tahoe"
          },
          {
            "date": "2023-10-13",
            "locationLatLong": "Latitude: 40.7131, Longitude: -74.0066",
            "locationName": "Columbia River"
          },
          {
            "date": "2023-10-12",
            "locationLatLong": "Latitude: 40.7132, Longitude: -74.0067",
            "locationName": "Hood Canal"
          }
        ]
      },
      {
        "buoyID": "w9348652",
        "name": "Buoy 3",
        "password": "password3",
        "authLevel": "owner",
        "updated": false,
        "MAC": "12:34:56:78:9A:BC",
        "locationData": [
          {
            "date": "2023-10-15",
            "locationLatLong": "Latitude: 40.7133, Longitude: -74.0068",
            "locationName": "Boulevard Park"
          },
          {
            "date": "2023-10-14",
            "locationLatLong": "Latitude: 40.7134, Longitude: -74.0069",
            "locationName": "Lake Washington"
          },
          {
            "date": "2023-10-13",
            "locationLatLong": "Latitude: 40.7135, Longitude: -74.0070",
            "locationName": "Snake River"
          },
          {
            "date": "2023-10-12",
            "locationLatLong": "Latitude: 40.7136, Longitude: -74.0071",
            "locationName": "Salish Sea"
          }
        ]
      },

    ];

    return http.Response(jsonEncode(jsonResponse), 200); // Use jsonEncode to convert the list to a JSON string
  }
}