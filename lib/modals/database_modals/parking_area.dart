import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/exceptions/scanner_exception.dart';
import 'package:scanner/modals/others/address.dart';
import 'package:scanner/modals/others/booking_status.dart';
import 'package:scanner/modals/others/owner.dart';
import 'package:scanner/utils/helpers/location_helper.dart';
import 'package:scanner/widgets/inherited_widgets/scanner.dart';

class ParkingArea {
  final String id;
  final String name;
  final Address address;
  final GeoFirePoint location;
  final List<String> images;
  final Owner owner;
  final int charges;

  ParkingArea({
    @required this.id,
    @required this.location,
    @required this.owner,
    @required this.address,
    @required this.name,
    @required this.images,
    @required this.charges,
  });

  static ParkingArea currentArea;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': address.street,
      'isoCode': address.isoCode,
      'country': address.country,
      'postalCode': address.postalCode,
      'state': address.state,
      'city': address.city,
      'locality': address.locality,
      'subLocality': address.subLocality,
      'location': location.data,
      'ownerName': owner.name,
      'ownerMail': owner.mailId,
      'images': images,
      'ownerContactNo': owner.contactNumber,
      'charges': charges,
    };
  }

  static Future<bool> isAlreadyParked(
      String vehicleId, String parkingId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('vehicleId', isEqualTo: vehicleId)
        .where(
          'status',
          isEqualTo: encodeBookingStatus(BookingStatus.parked),
        )
        .where('parkingId', isEqualTo: parkingId)
        .get();
    if (snapshot.docs.isEmpty) {
      return true;
    } else {
      throw ScannerException('Error',
          'This vehicle seems already parked and has not checked out yet. It cannot be parked again. Please check out and try again.');
    }
  }

  static Future<Booking> isBooked(String vehicleId, String parkingId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('vehicleId', isEqualTo: vehicleId)
        .where(
          'status',
          isEqualTo: encodeBookingStatus(BookingStatus.parked),
        )
        .where('parkingId', isEqualTo: parkingId)
        .get();
    if (snapshot.docs.isEmpty) {
      throw ScannerException("Not Parked",
          "No booking found for the user with specified phone and the vehicle number");
    } else {
      return Booking.fromMap(
          snapshot.docs.first.data(), snapshot.docs.first.id);
    }
  }

  static ParkingArea fromMap(Map<String, dynamic> map, String id) {
    GeoFirePoint location = geoPointTogeoFirePoint(map['location']['geopoint']);
    Address address = Address(
      city: map['city'],
      country: map['country'],
      isoCode: map['isoCode'],
      locality: map['locality'],
      postalCode: map['postalCode'],
      state: map['state'],
      street: map['street'],
      subLocality: map['subLocality'],
    );

    Owner owner = Owner(
      contactNumber: map['ownerContactNo'],
      mailId: map['ownerMail'],
      name: map['ownerName'],
    );
    return ParkingArea(
      id: id,
      location: location,
      owner: owner,
      address: address,
      name: map['name'],
      charges: map['charges'],
      images: map['images'],
    );
  }

  static List<ParkingArea> documentsToAreaList(
      List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.map((e) => ParkingArea.fromMap(e.data(), e.id)).toList();
  }

  static Future<ParkingArea> byId(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('parking_areas')
        .doc(id)
        .get();
    return ParkingArea.fromMap(snapshot.data(), id);
  }

  Future<String> getFullAddress() async {
    List<Placemark> placeemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Address a = Address.fromPlaceMark(placeemarks.first);
    return a.street +
        ', ' +
        a.subLocality +
        ', ' +
        a.city +
        ', ' +
        a.state +
        '.';
  }
}
