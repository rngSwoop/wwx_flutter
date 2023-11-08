import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import './shared/auth_buoys.dart';
import 'package:google_fonts/google_fonts.dart';

class BuoyDetailsScreen extends StatelessWidget {
  final AuthBuoys selectedAuthBuoys; // You need to define the AuthBuoys object

  BuoyDetailsScreen(this.selectedAuthBuoys);

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
      body: ListView.builder(
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
    );
  }
}