import 'package:flutter/material.dart';

const kLoginScreenId = 'login_screen';
const kRegisterScreenId = 'register_screen';
const kBuoysScreenId = 'buoys_screen.dart';
const kDataDisplayId = 'data_display_screen.dart';
const kIndividualBuoyScreen = 'individual_buoy_screen.dart';

const kThemeBlue = Color(0xFF00285E);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kThemeBlue, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kThemeBlue, width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);