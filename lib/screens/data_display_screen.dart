import 'package:buoy_flutter/screens/individual_buoy_screen.dart';
import 'package:flutter/material.dart';
import 'package:buoy_flutter/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import './shared/buoy_ids.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DataDisplayScreen extends StatefulWidget {
  List<BuoyData> data;
  DataDisplayScreen(this.data);

  @override
  State<DataDisplayScreen> createState() {
    return _DataDisplayState(this.data);
  }
}

class _DataDisplayState extends State<DataDisplayScreen> {
  List<BuoyData> data;
  _DataDisplayState(this.data);
  BuoyIDs buoyIDs = BuoyIDs();

  var dummyData = [BuoyData(21, 22, 23, 24, 25, 26, 27, 28, 29), BuoyData(31, 32, 33, 34, 35, 36, 37, 38, 39)];

 // '${data[0].time}, ${data[0].temp1}, ${data[0].temp2}, ${data[0].temp3}, ${data[0].salinity}, ${data[0].light}, ${data[0].turbidity}'
  List<Map<String, dynamic>> formatData(List<BuoyData> data) {
    List<Map<String, dynamic>> formattedData = [];

    for (int i = 0; i < data.length; i++) {
      var jsonData = {
        "timestamp": data[i].time.toString(),
        "surfTemp": data[i].temp1,
        "surfInsolation": data[i].light,
        "shallowSalinity": data[i].salinity,
        "shallowTemp": data[i].temp2,
        "depthTemp": data[i].temp3,
        "depthTurbidity": data[i].turbidity,
        "locationId": buoyIDs.locationID,
      };

      formattedData.add(jsonData);
    }
    print(formattedData);
    return formattedData;
  }


  postData () async {
    // Once we get actual data we want to change dummyData to our actual data list
    var formattedData = formatData(data);

    //200 -- success, 400, 404, 500
    try {
      var response = await http.post(
        //Here we want the actual website, this site just echos back what it receives
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formattedData), // Convert data to JSON format
      );
      //print(response.body);
      return response.body;
    } catch(e) {
      print(e);
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: Colors.white,
                        height: 100,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Data Collected at 5:56 p.m. on April 27, 2023",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataCard(
                        "Temperature",
                        "°F",
                        0,
                        180,
                        (((data[0].temp1.toDouble() + data[0].temp2.toDouble() + data[0].temp3.toDouble()) / 3.0) * (9/5)) + 32,
                      ),
                      DataCard(
                        "Salinity",
                        "g/L",
                        0,
                        80,
                        data[0].salinity.toDouble(),
                      ),
                      DataCard(
                        "Light",
                        "lux",
                        0,
                        1000,
                        data[0].light.toDouble()
                      ),
                      DataCard(
                        "Turbidity",
                        "NTU",
                        0,
                        100,
                        data[0].turbidity.toDouble()
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8.0, top: 8.0),
                          height: 80.0,
                          width: double.infinity,
                          child: Row( // Wrap the buttons in a Row
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
                            children: [
                              ElevatedButton(
                                // Send data to server
                                onPressed: () async {
                                  var response = await postData();
                                  // Display our response from the server
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 175),
                                      title: Text("Response From Server:"),
                                      content: Text("$response"),
                                      elevation: 24.0,
                                      scrollable: true,
                                    ),
                                    barrierDismissible: true,
                                  );
                                },
                                child: Text("Send Data"),
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(120.0, 50.0), // Set the width and height
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(kThemeBlue),
                                ),
                              ),
                              ElevatedButton(
                                // Disconnect action
                                onPressed: () {
                                  Navigator.pushNamed(context, kDashboardScreenId);
                                },
                                child: Text("Disconnect"),
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(120.0, 50.0), // Set the width and height
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Adjust color as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}

class DataCard extends StatelessWidget {
  final String title;
  final String units;
  final double min;
  final double max;
  final double val;

  DataCard(this.title, this.units, this.min, this.max, this.val);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 400,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              alignment: Alignment.center,
              child: Container(
                // color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.9,
                  alignment: Alignment.center,
                  child: SfRadialGauge(
                    title: GaugeTitle(
                      text: title,
                      textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    axes: <RadialAxis>[

                        RadialAxis(
                          annotations: [
                            GaugeAnnotation(
                              angle: 90,
                              // horizontalAlignment: GaugeAlignment.center,
                              //   verticalAlignment: GaugeAlignment.center,
                                widget: Text(
                                  "${double.parse(val.toStringAsFixed(1))} ${units}",
                                  style: GoogleFonts.lato(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                            )
                          ],
                          axisLineStyle: AxisLineStyle(
                            thickness: 15,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color(0xFFECECEC)
                          ),
                          showLabels: false,
                          minimum: min,
                          maximum: max,
                          // ranges: [
                          //   GaugeRange(
                          //       startValue: 0,
                          //       endValue: 333,
                          //       color: Colors.green,
                          //       startWidth: 10,
                          //       endWidth: 10
                          //   ),
                          //   GaugeRange(
                          //       startValue: 333,
                          //       endValue: 667,
                          //       color: Colors.orange,
                          //       startWidth: 10,
                          //       endWidth: 10
                          //   ),
                          //   GaugeRange(
                          //       startValue: 667,
                          //       endValue: 1000,
                          //       color: Colors.red,
                          //       startWidth: 10,
                          //       endWidth: 10
                          //   ),
                          // ],
                          pointers: [
                            // NeedlePointer(
                            //   value: val,
                            //   enableAnimation: true,
                            //   needleStartWidth: 0,
                            //   needleEndWidth: 5,
                            //   needleColor: Colors.blueGrey,
                            //   knobStyle: KnobStyle(
                            //     color: Colors.white,
                            //     borderColor: kThemeBlue,
                            //     knobRadius: 0.06,
                            //     borderWidth: 0.04),
                            //   tailStyle: TailStyle(
                            //     color: Colors.blueGrey,
                            //     width: 5,
                            //     length: 0.15)
                            // ),
                            RangePointer(
                              gradient: const SweepGradient(
                                  colors: <Color>[Colors.blueGrey, kThemeBlue],
                                  stops: <double>[0.25, 0.75]
                              ),
                              cornerStyle: CornerStyle.bothCurve,
                                value: val,
                                width: 15,
                                enableAnimation: true,
                                color: kThemeBlue
                            )
                          ],
                        )
                    ]
                  )
                ),
              )
            ),
        ),
      ],
    );
  }

}