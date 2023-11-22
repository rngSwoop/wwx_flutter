import 'dart:async';
import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import './shared/auth_buoys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:buoy_flutter/screens/data_display_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BuoyDetailsScreen extends StatelessWidget {
  final AuthBuoys selectedAuthBuoys; // Define the AuthBuoys object

  BuoyDetailsScreen(this.selectedAuthBuoys);

  // Define a FlutterBlue instance for Bluetooth functionality
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  Future<void> connectToDevice(String macAddress) async {
    var device;
    var subscription = flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        // Extract MAC address from this device.id
        String foundMAC = result.device.id.toString();
        print('Found device: $foundMAC');

        if (foundMAC == macAddress) {
          device = result.device;
          await device.connect();
          break;
        }
      }
    });

    // Set a timeout for scanning
    await Future.delayed(Duration(seconds: 5));

    // Cancel the subscription to stop scanning
    subscription.cancel();

    if (device != null) {
      // Device found and connected
      print('Connected to device: $macAddress');
      // Go to connected_screen.dart
      //Navigator.pushNamed(IndividualBuoyScreen(device));
    } else {
      // Device not found
      print('Device not found: $macAddress');
      // display to user
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedAuthBuoys.name} - ${selectedAuthBuoys.authLevel}', // Display the buoy name in the app bar
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kThemeBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedAuthBuoys.locationData.length,
              itemBuilder: (context, index) {
                final locationDataPoint = selectedAuthBuoys.locationData[index];
                return ListTile(
                  title: Text(
                    '${locationDataPoint.locationName}',
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Placed here on ${locationDataPoint.date}\n${locationDataPoint.locationLatLong}',
                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                );
              },
            ),
          ),

          // Button to initiate Bluetooth scanning
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8.0, top: 8.0),
              height: 80.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  connectToDevice(selectedAuthBuoys.MAC);
                },
                child: Text(
                  "Connect",
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
                  backgroundColor: MaterialStateProperty.all<Color>(kThemeBlue),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}