import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/database_modals/parking_area.dart';
import 'package:scanner/modals/database_modals/user.dart' as prkng;
import 'package:scanner/modals/database_modals/vehicle.dart';
import 'package:scanner/modals/exceptions/scanner_exception.dart';
import 'package:scanner/modals/others/booking_status.dart';

class Employee {
  final String id;
  final String parkingAreaId;
  final String name;
  final String contactNumber;
  final String emailId;

  Employee(
      {this.id,
      this.parkingAreaId,
      this.name,
      this.contactNumber,
      this.emailId});

  static Employee currentEmployee;

  static Employee fromFirebaseUser(User user) {
    return Employee(
      contactNumber: user.phoneNumber,
      emailId: user.email ?? 'your@example.com',
      id: user.uid,
    );
  }

  static fromMap(Map<String, dynamic> map, String id) {
    return Employee(
      name: map['name'],
      contactNumber: map['contactNumber'],
      emailId: map['emailId'],
      parkingAreaId: map['parkingAreaId'],
      id: id,
    );
  }

  static Future<Employee> current() async {
    String phoneNo = FirebaseAuth.instance.currentUser.phoneNumber;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('contactNumber', isEqualTo: phoneNo)
        .limit(1)
        .get();
    return Employee.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    return FirebaseFirestore.instance
        .collection('employees')
        .where('contactNumber', isEqualTo: contactNumber)
        .limit(1)
        .snapshots();
  }

  static Future<Booking> book(String phoneNo, String vehicleNo) async {
    try {
      prkng.User user = await prkng.User.byContactNumber(phoneNo);
      Vehicle vehicle = await Vehicle.getUserVehicle(user.id, vehicleNo);
      ParkingArea parkingArea =
          await ParkingArea.byId(Employee.currentEmployee.parkingAreaId);
      await ParkingArea.isAlreadyParked(vehicle.id, parkingArea.id);
      Booking booking = Booking(
        vehicle: vehicle,
        userId: user.id,
        from: DateTime.now(),
        till: DateTime.now(),
        status: BookingStatus.parked,
        parkingId: Employee.currentEmployee.parkingAreaId,
        charges: parkingArea.charges,
        employeeId: Employee.currentEmployee.id,
        transactionId: "Transaction_ID",
      );
      return booking;
    } catch (e) {
      if (e is ScannerException) {
        rethrow;
      } else {
        throw ScannerException(
          'User not found',
          'No user found for the corresponding phone number, please try again.',
        );
      }
    }
  }

  static Future exit(String phoneNo, String vehicleNo) async {
    prkng.User user = await prkng.User.byContactNumber(phoneNo);
    Vehicle vehicle = await Vehicle.getUserVehicle(user.id, vehicleNo);
    ParkingArea parkingArea =
        await ParkingArea.byId(Employee.currentEmployee.parkingAreaId);
    Booking booking = await ParkingArea.isBooked(vehicle.id, parkingArea.id);
    booking.endSession();
  }

  static Future<bool> exists(String phoneNo) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('contactNumber', isEqualTo: phoneNo)
        .get();
    return snapshot.docs.isEmpty ? false : true;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'emailId': emailId,
      'parkingAreaId': parkingAreaId,
    };
  }
}
