import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/screens/authscreens/authscreen.dart';
import 'package:scanner/screens/homescreens/homescreen.dart';
import 'package:flutter/material.dart';

class Authenticator extends StatelessWidget {
  const Authenticator({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Employee.currentEmployee != null) {
      return const HomeScreen();
    }
    return const AuthScreen();
  }
}
