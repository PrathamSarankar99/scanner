import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner/modals/database_modals/vehicle.dart';
import 'package:scanner/modals/others/booking_status.dart';
import 'package:scanner/modals/others/vehicle_type.dart';

class Booking {
  final String id;
  final String parkingId;
  final String userId;
  final Vehicle vehicle;
  final String transactionId;
  final DateTime from;
  final DateTime till;
  final String employeeId;
  final int charges;
  final BookingStatus status;
  Booking({
    this.id,
    this.parkingId,
    this.userId,
    this.vehicle,
    this.employeeId,
    this.transactionId,
    this.from,
    this.till,
    this.charges,
    this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Booking &&
        other.userId == userId &&
        other.vehicle == vehicle &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode => super.hashCode;

  Map<String, dynamic> toMap() {
    return {
      // Vehicle object
      'name': vehicle.name,
      'userId': userId,
      'number': vehicle.number,
      'isPrimary': vehicle.isPrimary,
      'vehicleType': encodeVehicle(vehicle.type),

      "parkingId": parkingId,
      "vehicleId": vehicle.id,
      "transactionId": transactionId,
      "employeeId": employeeId,
      "from": from,
      "till": till,
      "charges": charges,
      "status": encodeBookingStatus(status),
    };
  }

  endSession() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('bookings').doc(id).get();
    snapshot.reference.update({
      "till": DateTime.now(),
      "status": encodeBookingStatus(BookingStatus.over),
    });
  }

  static fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      parkingId: map["parkingId"],
      userId: map["userId"],
      vehicle: Vehicle.fromMap(
        map,
        map['vehicleId'],
      ),
      transactionId: map['transactionId'],
      from: (map["from"] as Timestamp).toDate(),
      till: (map["till"] as Timestamp).toDate(),
      charges: map["charges"],
      employeeId: map["employeeId"],
      status: decodeBookingStatus(map["status"]),
      id: id,
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> stream(String id) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('employeeId', isEqualTo: id)
        .orderBy('from', descending: true)
        .snapshots();
  }
}

List<Booking> dummyBookings = [
  Booking(
    userId: "lU0ae6kAEBRApm4ghpcb7pM12V52",
    charges: 15,
    vehicle: Vehicle(
      id: "11xzfaqDNh8BQAmwFPVg",
      isPrimary: true,
      name: "Grand i10",
      number: "MP - 04 - CJ - 8761",
      type: VehicleType.car,
      userId: "lU0ae6kAEBRApm4ghpcb7pM12V52",
    ),
    from: DateTime(2021, 9, 7, 17, 30),
    till: DateTime(2021, 9, 7, 22, 50),
    id: "IDNUMBERONE",
    status: BookingStatus.over,
    transactionId: "TRANSACTIONID",
    parkingId: "GLaSK5MtRxbf87gkcPFz",
  ),
  Booking(
    userId: "lU0ae6kAEBRApm4ghpcb7pM12V52",
    charges: 20,
    vehicle: Vehicle(
      id: "11xzfaqDNh8BQAmwFPVg",
      isPrimary: true,
      name: "Avenger 220",
      number: "MP - 04 - CL - 8991",
      type: VehicleType.bike,
      userId: "lU0ae6kAEBRApm4ghpcb7pM12V52",
    ),
    from: DateTime(2021, 9, 11, 18, 40),
    till: DateTime(2021, 9, 11, 22, 50),
    id: "IDNUMBERONE",
    status: BookingStatus.parked,
    transactionId: "TRANSACTIONID",
    parkingId: "GLaSK5MtRxbf87gkcPFz",
  ),
];
