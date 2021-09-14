// import 'package:flutter/material.dart';
// import 'package:scanner/modals/database_modals/employee.dart';
// import 'package:scanner/modals/database_modals/parking_area.dart';

// class Scanner extends InheritedWidget {
//   const Scanner({
//     Key key,
//     @required this.employee,
//     @required this.parkingArea,
//     @required Widget child,
//   }) : super(key: key, child: child);

//   final Employee employee;
//   final ParkingArea parkingArea;

//   static Scanner of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<Scanner>();
//   }

//   @override
//   bool updateShouldNotify(covariant Scanner oldWidget) {
//     return employee != oldWidget.employee;
//   }
// }
