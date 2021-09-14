import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/modals/database_modals/parking_area.dart';
import 'package:scanner/modals/database_modals/user.dart';
import 'package:scanner/widgets/auth_widgets/authenticator.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (await User.isLoggedIn()) {
    Employee.currentEmployee = await Employee.current();
    ParkingArea.currentArea =
        await ParkingArea.byId(Employee.currentEmployee.parkingAreaId);
  }
  runApp(const Scanner());
}

class Scanner extends StatelessWidget {
  const Scanner({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authenticator(),
    );
  }
}
