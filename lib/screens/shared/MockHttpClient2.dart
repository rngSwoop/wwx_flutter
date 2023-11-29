import 'dart:convert';
import 'package:http/http.dart' as http;

class MockHttpClient2 {
  MockHttpClient2();

  Future<http.Response> get(Uri url) async {
    final jsonResponse = {
      "ownedBuoys": [
        {
          "id": 3,
          "name": "test",
          "mac": "12:34:te:st:te:st",
          "pubKey": null,
          "lastRetrieval": null,
          "version": null,
          "createdAt": "2023-11-28T21:13:03.298Z",
          "updatedAt": "2023-11-28T21:13:03.298Z",
          "groupId": 2,
          "userId": 1,
          "locationId": 1
        }
      ],
      "managedBuoys": [
        {
          "id": 1,
          "name": "proto",
          "mac": "FF-FF-FF-FF-FF-FF",
          "pubKey": null,
          "lastRetrieval": null,
          "version": null,
          "createdAt": "2023-11-28T21:13:03.298Z",
          "updatedAt": "2023-11-28T21:13:03.298Z",
          "groupId": 1,
          "userId": 2,
          "locationId": 1
        },
        {
          "id": 2,
          "name": "salish",
          "mac": "12:34:56:78:9A:BC",
          "pubKey": null,
          "lastRetrieval": null,
          "version": null,
          "createdAt": "2023-11-28T21:13:03.298Z",
          "updatedAt": "2023-11-28T21:13:03.298Z",
          "groupId": 2,
          "userId": 2,
          "locationId": 1
        }
      ],
      "authorizedBuoys": [
        {
          "id": 2,
          "name": "salish",
          "mac": "12:34:56:78:9A:BC",
          "pubKey": null,
          "lastRetrieval": null,
          "version": null,
          "createdAt": "2023-11-28T21:13:03.298Z",
          "updatedAt": "2023-11-28T21:13:03.298Z",
          "groupId": 2,
          "userId": 2,
          "locationId": 1
        }
      ]
    };

    return http.Response(jsonEncode(jsonResponse), 200);
  }
}