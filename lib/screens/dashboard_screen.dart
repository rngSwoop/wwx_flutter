import 'package:flutter/material.dart';
import './shared/auth_buoys.dart';
import 'package:buoy_flutter/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import './shared/MockHttpClient.dart';
import 'package:http/http.dart' as http; // For when API endpoint is set up
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<AuthBuoys> authBuoys = []; // List of AuthBuoys
  final ScrollController _scrollController = ScrollController();
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _fetchData();

    // Attach a listener to the scroll controller to detect when the user scrolls to the top
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0) {
        // User has scrolled to the top, trigger a refresh
        _refreshData();
      }
    });
  }

  // Fetch data via HTTP GET request
  // Update the 'authBuoys' list with fetched data
  Future<void> _fetchData() async {
    // Expected JSON-formatted data:
    // [
    //   {
    //     "name": "Buoy 1",
    //     "password": "password1",
    //     "authLevel": "user",
    //     "updated": true
    //   },
    //   // ... more objects ...
    // ]

    // Create a mock HTTP client
    final mockClient = MockHttpClient();
    // Once API endpoint is set up, replace
    // final mockClient = MockHttpClient();
    // with
    // final client = http.Client();

    // Simulate an API call
    // Replace with client.get(Uri.parse('https://your-api-endpoint.com')).then((response)
    mockClient.get(Uri.parse('https://your-api-endpoint.com')).then((response) {
      if (response.statusCode == 200) {
        // Parse the JSON response and populate the authBuoys list
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          // Create AuthBuoys objects from JSON data
          authBuoys = jsonData.map((map) => AuthBuoys.fromJson(map)).toList();
        });
      } else if (response.statusCode == 404) {
        // Handle 404 error (Not Found)
        print('404 (Not Found');
      } else if (response.statusCode == 500) {
        // Handle 500 error (Internal Server Error)
        print('500 (Internal Server Error)');
      } else {
        // Handle other error
        print('API request failed with status code ${response.statusCode}');
      }
    });
  }

  Future<void> _refreshData() async {
    if (isRefreshing) return;
    setState(() {
      isRefreshing = true;
    });

    // Perform the refresh action, e.g., fetch updated data from the API
    await _fetchData(); // Fetch data again

    print('Data fetched');
    setState(() {
      isRefreshing = false;
    });
  }

  // Function to create consistent styled buttons
  ElevatedButton styledButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(4.0),
        shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(kThemeBlue), // Use kThemeBlue
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'My Buoys',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kThemeBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: authBuoys.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('Gesture Detected for index $index');
                      //Handle selection of a specific buoy
                      //Navigator.pushNamed(
                      //  context,
                      //  kBuoyDetailsScreenId,
                      //  arguments: authBuoys[index], // Pass the selected buoy data
                      //);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            authBuoys[index].name,
                            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            authBuoys[index].authLevel,
                            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          // Add more details or actions as needed
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Button to initiate Bluetooth scanning
          styledButton(
            text: 'Scan For Devices',
            onPressed: () {
              // Navigate to the Bluetooth scanning screen
              Navigator.pushNamed(context, kBuoysScreenId);
              // or implement Bluetooth scanning logic here
            },
          ), // StyledButton
          // Button to change password
          styledButton(
            text: 'Change Password',
            onPressed: () {
              // Show a password change dialog or navigate to a password change screen
            },
          ), // StyledButton
        ],
      ),
    );
  }
}