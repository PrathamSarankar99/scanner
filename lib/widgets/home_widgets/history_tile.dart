import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/others/booking_status.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({Key key, this.booking}) : super(key: key);
  final Booking booking;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            booking.vehicle.number,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          subtitle: Row(
            children: [
              if (booking.status == BookingStatus.parked)
                Container(
                  height: 11,
                  width: 11,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                booking.status == BookingStatus.parked
                    ? "Parked"
                    : "Paid ₹15 for${formatDuration(booking.till.difference(booking.from))}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (booking.from.day - DateTime.now().day) == 0
                    ? 'Today'
                    : (booking.from.day - DateTime.now().day == 1)
                        ? "Yesterday"
                        : "${booking.from.day}/${booking.from.month}/${booking.from.year}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                formatTime(booking),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  String formatTime(Booking booking) {
    return '${(booking.from.hour).toString().padLeft(2, '0')}:${booking.from.minute.toString().padLeft(2, '0')} ${booking.status == BookingStatus.parked ? "" : " - ${(booking.till.hour).toString().padLeft(2, '0')}:${booking.till.minute.toString().padLeft(2, '0')}"}';
  }

  String formatDuration(Duration duration) {
    return (duration.inHours ~/ 60 != 0
            ? (duration.inHours ~/ 60).toString() + " "
            : " ") +
        (duration.inMinutes % 60).toString() +
        " mins";
  }
}
