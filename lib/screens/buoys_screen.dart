import 'package:buoy_flutter/screens/data_display_screen.dart';
import 'package:buoy_flutter/screens/individual_buoy_screen.dart';
import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BuoysScreen extends StatefulWidget {
  @override
  State<BuoysScreen> createState() => _BuoysScreenState();
}

class _BuoysScreenState extends State<BuoysScreen> {
  var deviceList = [];
  var scanning = false;
  var scanButtonText = 'Start Scanning';
  List<Widget> bluetoothItemList = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      Permission.bluetoothScan.request();
      Permission.bluetoothConnect.request();

      deviceList = [];
      bluetoothItemList = [];

      flutterBlue.startScan(timeout: const Duration(seconds: 2));
      var subscription = flutterBlue.scanResults.listen((results) async {
        for (ScanResult r in results) {
          if (r.device.name != "") {
            if (!deviceList.contains(r.device)) {
              deviceList.add(r.device);
              bluetoothItemList.add(
                  BluetoothItem(
                      r.device.name,
                      Icons.bluetooth,
                      r.device
                  )
              );
            }
          }
        }
      });

      subscription.onDone(() {
        flutterBlue.stopScan();
        setState(() {
          bluetoothItemList = bluetoothItemList.isEmpty
              ? [Text("No devices found.")]
              : bluetoothItemList;
        });
      });
    });
  }

  List<BuoyData> dataPoints = [BuoyData(
    12,  // TIME
    14,  // TEMP1
    15,  // TEMP2
    14,  // TEMP3
    37,  // SALINITY (RANGE FROM 0-80) (Dead Sea is ~342)
    500, // LIGHT (IN LUX) (100 - 1000 is avg range at 6ft)
    15  // TURBIDITY (Clear Ocean water 6ft below is 0.1 - 1 NTU, rivers and streams can be 10 to 100
  )];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // TODO: FIX SET STATE ERROR, THE VISUAL LIST (GREEN BOXES) ONLY UPDATES ON HOT RELOAD
                    // TODO: NOW "FIXED" BELOW IN THE ONPRESSED() SINCE IT SCANS IN THE INITSTATE() AS WELL, BETTER SOLUTION NEEDED
                  children: bluetoothItemList
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8.0, top: 8.0),
                  height: 80.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // startScan();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataDisplayScreen(dataPoints)
                          )
                      );
                      // bluetoothItemList = bluetoothItemList.isEmpty ? [Text("No devices found.")]
                      //     : bluetoothItemList;
                    },
                    child: Text(
                      "Start Scan",
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
                        backgroundColor: MaterialStateProperty.all<Color>(kThemeBlue)
                    ),
                  )
              ),
            )
          ],
        ),

      ),
    );
  }
}

class BluetoothItem extends StatelessWidget {
  const BluetoothItem(this.label, this.icon, this.device);

  final String label;
  final IconData icon;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: TextButton(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
                child: Icon(
                  icon,
                  color: kThemeBlue,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  color: kThemeBlue
                ),
              ),
            ],
          ),
          // TODO: DISPLAY ERROR MESSAGE INSTEAD PRINT IF NECESSARY
          // TODO: FIX THE FACT THAT THE context.loaderOverlay IS NOT SHOWING
          onPressed: () async {
            try {
              context.loaderOverlay.show();
              await device.connect(); // CONNECTS TO DEVICE PRESSED
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndividualBuoyScreen(device)
                  )
              );
            } catch (e) {
              print(e);
            }

            context.loaderOverlay.hide();


          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(4.0),
            shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}


