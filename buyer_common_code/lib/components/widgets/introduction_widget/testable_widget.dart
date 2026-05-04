import 'package:flutter/material.dart';

Widget testableWidget({required Widget child}) {
  return MaterialApp(home: Scaffold( backgroundColor: Colors.white,body: child));
}
