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
      },
      {
        "buoyID": "12983t",
        "name": "Buoy 2",
        "password": "password2",
        "authLevel": "manager",
        "updated": true,
      },
      {
        "buoyID": "w9348652",
        "name": "Buoy 3",
        "password": "password3",
        "authLevel": "owner",
        "updated": false,
      },

    ];

    return http.Response(jsonEncode(jsonResponse), 200); // Use jsonEncode to convert the list to a JSON string
  }
}