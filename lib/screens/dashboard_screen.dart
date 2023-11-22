import 'package:buoy_flutter/screens/shared/buoy_ids.dart';
import 'package:flutter/material.dart';
import './shared/auth_buoys.dart';
import 'package:buoy_flutter/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import './shared/MockHttpClient.dart';
import 'package:http/http.dart' as http; // For when API endpoint is set up
import 'dart:convert';
import './buoys_screen.dart'; // Import buoys_screen.dart which contains our bluetooth functionality

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<AuthBuoys> authBuoys = []; // List of AuthBuoys
  BuoyIDs buoyIDs = BuoyIDs(); // Create instance to our globally stored buoy variables
  final ScrollController _scrollController = ScrollController();
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _fetchData();

    // Reset globally stored IDs, as the user is yet to select a buoy
    _resetBuoyIDs();

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
  // Expected JSON-formatted data:
  // [
  //   {
  //     "buoyID": "123",
  //     "name": "Buoy 1",
  //     "password": "password1",
  //     "authLevel": "user",
  //     "updated": true,
  //     "locationData": [{date, locationLatLong, locationName},{...}]
  //   },
  //   // ... more objects ...
  // ]
  Future<void> _fetchData() async {

    // Create a mock HTTP client
    // Once API endpoint is set up, replace final mockClient = MockHttpClient(); with
    // final client = http.Client();
    final mockClient = MockHttpClient();

    // Simulate an API call
    // Replace with client.get(Uri.parse('https://your-api-endpoint.com')).then((response)
    mockClient.get(Uri.parse('https://your-api-endpoint.com')).then((response) {
      if (response.statusCode == 200) {
        // Parse the JSON response and populate the authBuoys list
        final List<dynamic> jsonData = json.decode(response.body);

        // Create AuthBuoys objects from JSON data
        setState(() {
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

  // Reset globally stored buoy IDs when user navigates to this screen
  void _resetBuoyIDs() {
    // Reset BuoyIDs to default values
    buoyIDs.updateIDs(-1, -1); // Reset to -1
    print('Set buoyID: ${buoyIDs.buoyID}, locationID: ${buoyIDs.locationID}');
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
    return DefaultTabController(
      length: 2, // Number of tabs (My Buoys and Near Me)
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Buoy Dashboard',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: kThemeBlue,
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Buoys'),
              Tab(text: 'Near Me'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // My Buoys Tab
            _buildMyBuoysTab(),
            // Near Me Tab (You can add your Near Me content here)
            _buildNearMeTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyBuoysTab() {
    return Column(
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
                    // Update globally stored buoyID and locationID to this buoy
                    buoyIDs.updateIDs(authBuoys[index].buoyID, authBuoys[index].locationID);
                    print('Set buoyID: ${buoyIDs.buoyID}, locationID: ${buoyIDs.locationID}');
                    // Handle selection of a specific buoy
                    Navigator.pushNamed(
                      context,
                      kBuoyDetailsScreenId,
                      arguments: authBuoys[index], // Pass the selected buoy data
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          authBuoys[index].name,
                          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${authBuoys[index].authLevel} - ${authBuoys[index].locationID} - ${authBuoys[index].buoyID}',
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
      ],
    );
  }

  Widget _buildNearMeTab() {
    return BluetoothScan(); // Return an instance of BluetoothScan
  }
}