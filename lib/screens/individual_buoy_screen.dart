import 'package:buoy_flutter/screens/data_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';

class IndividualBuoyScreen extends StatefulWidget {
  BluetoothDevice device;
  IndividualBuoyScreen(this.device);

  @override
  State<IndividualBuoyScreen> createState() {
    return _IndividualBuoyState(this.device);
  }

}

class _IndividualBuoyState extends State<IndividualBuoyScreen> {
  BluetoothDevice device;
  _IndividualBuoyState(this.device);



  void startRecord() async {
    List<BluetoothService> services = await device.discoverServices();  // ALL THE SERVICES ATTACHED TO THAT DEVICE
    BluetoothCharacteristic? c1;
    BluetoothCharacteristic? c2;
    services.forEach((service) async {  // FOR EVERY SERVICE IN THE LIST OF SERVICES
      for (BluetoothCharacteristic c in service.characteristics) {  // THE BUOY WILL HAVE A BUNCH OF CHARACTERISTICS

        if (c.serviceUuid == Guid('44332211-4433-2211-4433-221144332211')) {  // THIS SERVICE UUID MATTERs - THIS IS THE SERVICE UUID THAT TRANSFERS THE DATA, THERE WILL BE TWO (THEY ARE HARDCODED INTO THE BUOY)
          print('CHARACTERISTIC ${c}');
          if (c.uuid == Guid('0000abc0-0000-1000-8000-00805f9b34fb')) {  // THIS IS THE UUID NEEDED TO WRITE - SENDS A REQUEST TO THE BUOY TO GIVE THE DATA
            c1 = c;  // CONTROL - TELLS THE BUOY WHAT TO EXPECT (IF THE APP IS GOING TO SEND BUOY DATA)
          }
          if (c.uuid == Guid('0000abc1-0000-1000-8000-00805f9b34fb')) {  // THIS IS THE UUID NEEDED TO READ
            c2 = c;  // DATA
          }
        }
      }
    });

    await c1!.write([0x02, 0x00]);
    await c2!.write([0x00, 0x00, 0x00, 0x00]);
  }

  void collectRecordedData() async {
    List<BluetoothService> services = await device.discoverServices();  // ALL THE SERVICES ATTACHED TO THAT DEVICE
    // BluetoothCharacteristic? c1;
    BluetoothCharacteristic? c2;
    services.forEach((service) async {  // FOR EVERY SERVICE IN THE LIST OF SERVICES
      for (BluetoothCharacteristic c in service.characteristics) {  // THE BUOY WILL HAVE A BUNCH OF CHARACTERISTICS

        if (c.serviceUuid == Guid('44332211-4433-2211-4433-221144332211')) {  // THIS SERVICE UUID MATTERs - THIS IS THE SERVICE UUID THAT TRANSFERS THE DATA, THERE WILL BE TWO (THEY ARE HARDCODED INTO THE BUOY)
          print('CHARACTERISTIC ${c}');
          // if (c.uuid == Guid('0000abc0-0000-1000-8000-00805f9b34fb')) {  // THIS IS THE UUID NEEDED TO WRITE - SENDS A REQUEST TO THE BUOY TO GIVE THE DATA
          //   c1 = c;  // CONTROL - TELLS THE BUOY WHAT TO EXPECT (IF THE APP IS GOING TO SEND BUOY DATA)
          // }
          if (c.uuid == Guid('0000abc1-0000-1000-8000-00805f9b34fb')) {  // THIS IS THE UUID NEEDED TO READ
            c2 = c;  // DATA
          }
        }
      }
    });

    List<int> val = await c2!.read();
    print('VALUE1: $val');

    List<BuoyData> dataPoints = [];
    for (var i = 0; i < val[0]; i++) {
      List<int> rawData = await c2!.read();
      print('RAW DATA FROM THE BUOY ${rawData}');
      // int time = rawData[0] & (rawData[1] << 8) & (rawData[2] << 16) & (rawData[3] << 24);
      // int temp1 = rawData[4] & (rawData[5] << 8);
      // int temp2 = rawData[6] & (rawData[7] << 8);
      // int temp3 = rawData[8] & (rawData[9] << 8);
      // int salinity = rawData[10] & (rawData[11] << 8);
      // int light = rawData[12] & (rawData[13] << 8);
      // int turbidity = rawData[15] & (rawData[15] << 8);
      dataPoints.add(
          BuoyData(
              rawData[0] | (rawData[1] << 8) | (rawData[2] << 16) | (rawData[3] << 24),  // SECONDS
              rawData[4] | (rawData[5] << 8),  // CELSIUS
              rawData[6] | (rawData[7] << 8),  // CELSIUS
              rawData[8] | (rawData[9] << 8),  // CELSIUS
              rawData[10] | (rawData[11] << 8),  // SALINITY: (IN SALINITY)
              rawData[12] | (rawData[13] << 8),  // LIGHT: LUX
              rawData[14] | (rawData[15] << 8)  // TURBIDITY: NTU (NEPHELOMETRIC TURBIDITY UNITS)
          )
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DataDisplayScreen(dataPoints)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var dataPoints = [BuoyData(0, 13, 14, 14, 32, 80, 5)];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Container(

              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 80,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                            padding: EdgeInsets.only(left: 16, right: 8, bottom: 8.0, top: 8.0),
                            height: 80.0,

                            child: ElevatedButton(
                              onPressed: () {
                                startRecord();
                              },
                              child: Text(
                                "Start Recording",
                                textAlign: TextAlign.center,
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
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                            padding: EdgeInsets.only(left: 8, right: 16, bottom: 8.0, top: 8.0),
                            height: 80.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                collectRecordedData();
                              },
                              child: Text(
                                "Collect Recorded Data",
                                textAlign: TextAlign.center,
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
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8.0, top: 8.0),
                      height: 80.0,
                      child: ElevatedButton(
                        onPressed: () {
                          device.disconnect();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Disconnect",
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
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                        ),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuoyData {
  int time;
  int temp1;
  int temp2;
  int temp3;
  int salinity;
  int light;
  int turbidity;

  BuoyData(
      this.time,
      this.temp1,
      this.temp2,
      this.temp3,
      this.salinity,
      this.light,
      this.turbidity
  );
}
