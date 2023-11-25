import 'dart:async';
import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import './shared/auth_buoys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:buoy_flutter/screens/individual_buoy_screen.dart';
import 'package:buoy_flutter/screens/data_display_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BuoyDetailsScreen extends StatelessWidget {
  final AuthBuoys selectedAuthBuoys; // Define the AuthBuoys object

  BuoyDetailsScreen(this.selectedAuthBuoys);

  // Define a FlutterBlue instance for Bluetooth functionality
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  Future<BluetoothDevice?> connectToDevice(BuildContext context, String macAddress) async {
    try {
      // context.loaderOverlay.show();
      var device;
      var subscription = flutterBlue.scanResults.listen((results) async {
        for (ScanResult result in results) {
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

      subscription.cancel();
      // context.loaderOverlay.hide();

      return device;
    } catch (e) {
      print('Error connecting to device: $e');
      // context.loaderOverlay.hide();
      return null;
    }
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connection Error'),
          content: Text('The device could not be found. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void onPressed(BuildContext context, String macAddress) {
    context.loaderOverlay.show();
    connectToDevice(context, macAddress).then((device) {
      context.loaderOverlay.hide();

      if (device != null) {
        // Device found and connected
        print('Connected to device: $macAddress');
        // Navigate to new screen and pass the connected device
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualBuoyScreen(device),
          ),
        );
      } else {
        // Device not found
        print('Device not found: $macAddress');
        showErrorDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidget: Center(
        child: CircularProgressIndicator(), // Customize your loader here
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${selectedAuthBuoys.name} - ${selectedAuthBuoys.authLevel}',
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
                  final locationDataPoint = selectedAuthBuoys
                      .locationData[index];
                  return ListTile(
                    title: Text(
                      '${locationDataPoint.locationName}',
                      style: GoogleFonts.lato(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Placed here on ${locationDataPoint
                          .date}\n${locationDataPoint.locationLatLong}',
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Container(
                padding: EdgeInsets.only(
                    left: 16, right: 16, bottom: 8.0, top: 8.0),
                height: 80.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onPressed(context, selectedAuthBuoys.MAC);
                  },
                  child: Text(
                    "Connect",
                    style: GoogleFonts.lato(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(4.0),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        kThemeBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}