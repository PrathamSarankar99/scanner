import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner/modals/exceptions/scanner_exception.dart';
import 'package:scanner/modals/others/vehicle_type.dart';
import 'package:scanner/widgets/inherited_widgets/scanner.dart';

class Vehicle {
  final String id;
  final String userId;
  final String number;
  final bool isPrimary;
  final String name;
  final VehicleType type;

  Vehicle({
    this.id,
    this.userId,
    this.number,
    this.type,
    this.isPrimary,
    this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Vehicle && other.number == number;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'number': number,
      'isPrimary': isPrimary,
      'vehicleType': encodeVehicle(type),
    };
  }

  static Vehicle fromMap(Map<String, dynamic> map, String id) {
    return Vehicle(
      id: id,
      isPrimary: map['isPrimary'],
      name: map['name'],
      number: map['number'],
      type: decodeVehicle(map['vehicleType']),
      userId: map['userId'],
    );
  }

  static Future<Vehicle> getUserVehicle(
      String userId, String vehicleNumber) async {
    List<Vehicle> vehicleList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> vehicleSnapshot =
          await FirebaseFirestore.instance
              .collection('vehicles')
              .where('userId', isEqualTo: userId)
              .where('number', isEqualTo: vehicleNumber)
              .limit(1)
              .get();
      vehicleList = Vehicle.listFromSnapshot(vehicleSnapshot);
      return vehicleList.first;
    } catch (e) {
      if (e is ScannerException) {
        rethrow;
      }
      throw ScannerException(
        "Vehicle not found",
        'You have entered wrong vehicle number, or may be the user has not added this vehicle yet.',
      );
    }
  }

  delete() {
    FirebaseFirestore.instance.collection('vehicles').doc(id).delete();
  }

  Future<String> add() async {
    DocumentReference<Map<String, dynamic>> document =
        await FirebaseFirestore.instance.collection('vehicles').add(toMap());
    return document.id;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      currentUserVehiclesStream() {
    return FirebaseFirestore.instance
        .collection('vehicles')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      currentUserPrimaryVehiclesStream() {
    return FirebaseFirestore.instance
        .collection('vehicles')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('isPrimary', isEqualTo: true)
        .snapshots();
  }

  static List<Vehicle> listFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Vehicle.fromMap(e.data(), e.id)).toList();
  }

  static Future<Vehicle> getCurrentPrimaryVehicle() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('vehicles')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('isPrimary', isEqualTo: true)
        .get();
    return Vehicle.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  static changePrimary(String vehicleID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('vehicles')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    for (var element in snapshot.docs) {
      element.reference.update({
        'isPrimary': element.id == vehicleID ? true : false,
      });
    }
  }
}

var dummyVehicles = [
  Vehicle(
    id: '1',
    name: 'Grand i10',
    number: 'MP-04-9351',
    type: VehicleType.car,
    userId: 'pratham',
    isPrimary: true,
  ),
  Vehicle(
    id: '1',
    name: 'Avenger 220',
    number: 'MP-07-9826',
    type: VehicleType.bike,
    userId: 'pratham',
    isPrimary: true,
  ),
  Vehicle(
    id: '1',
    name: 'Audi 800',
    number: 'DL-05-8231',
    type: VehicleType.car,
    userId: 'pratham',
    isPrimary: false,
  ),
];
