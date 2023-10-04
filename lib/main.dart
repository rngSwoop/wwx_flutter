import 'package:buoy_flutter/screens/individual_buoy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'constants.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/buoys_screen.dart';
import 'screens/data_display_screen.dart';
import 'screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: kLoginScreenId,
      routes: {
        kLoginScreenId: (context) => LoginScreen(),
        kRegisterScreenId: (context) => RegisterScreen(),
        kBuoysScreenId: (context) => BuoysScreen(),
        kDashboardScreenId: (context) => DashboardScreen(),
        // kIndividualBuoyScreen: (context) => IndividualBuoyScreen()
      },
    );
  }
}
