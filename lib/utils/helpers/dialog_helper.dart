import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/modals/exceptions/scanner_exception.dart';

showCongratsDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Congrats',
        style: GoogleFonts.poppins(
          fontSize: 23,
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'The user and the vehicle is verified. You can confirm the booking now or cancel it now.',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            'Confirm',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

showScannerExceptionDialog(BuildContext context, ScannerException exception) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        exception.title,
        style: GoogleFonts.poppins(
          fontSize: 23,
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        exception.details,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Okay',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
