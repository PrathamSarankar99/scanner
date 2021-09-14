import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/modals/database_modals/parking_area.dart';
import 'package:scanner/modals/database_modals/vehicle.dart';
import 'package:scanner/modals/exceptions/scanner_exception.dart';
import 'package:scanner/utils/helpers/dialog_helper.dart';
import 'package:scanner/utils/helpers/texthelper.dart';
import 'package:scanner/widgets/home_widgets/app_drawer.dart';
import 'package:scanner/widgets/home_widgets/history_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key, this.changeTab}) : super(key: key);
  final Function(int) changeTab;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController phoneController;
  GlobalKey<ScaffoldState> scaffoldkey;
  TextEditingController vehicleController;
  @override
  void initState() {
    phoneController = TextEditingController();
    vehicleController = TextEditingController();
    scaffoldkey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: AppDrawer(
        changeTab: widget.changeTab,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              'History',
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                color: Colors.black.withOpacity(0.75),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: RotatedBox(
                                quarterTurns: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, right: 5),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.blue.shade700,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Booking.stream(Employee.currentEmployee.id),
                          builder: (context, streamSnapshot) {
                            if (!streamSnapshot.hasData) {
                              return Container();
                            }

                            return ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 5),
                              children: streamSnapshot.data.docs
                                  .map(
                                    (e) => HistoryTile(
                                      booking: Booking.fromMap(e.data(), e.id),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manual',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Phone no.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.65),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.grey.shade800,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(children: [
                          Expanded(
                            flex: 17,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+91',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 83,
                            child: Container(
                              color: Colors.transparent,
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  hintText: 'Enter phone number',
                                ),
                              ),
                            ),
                          ),
                        ]),
                        height: 50,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Vehicle no.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.65),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.grey.shade800,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 50,
                        child: TextField(
                          controller: vehicleController,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade800,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: const EdgeInsets.only(left: 15),
                            hintText: 'XX - XX - XX - XXXX',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 52,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    top: 10, bottom: 5, right: 18, left: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade500),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 2 - 20,
                                50)),
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              Booking booking = await Employee.book(
                                formatIndiaNumber(phoneController.text),
                                vehicleController.text,
                              );
                              showCongratsDialog(
                                context,
                                () {
                                  FirebaseFirestore.instance
                                      .collection('bookings')
                                      .add(booking.toMap());
                                  Navigator.pop(context);
                                },
                              );
                            } on ScannerException catch (e) {
                              showScannerExceptionDialog(context, e);
                            }
                          },
                          child: Text(
                            'Entry',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade900),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 2, 50)),
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await Employee.exit(
                                formatIndiaNumber(phoneController.text),
                                vehicleController.text,
                              );
                              showScannerExceptionDialog(
                                  context,
                                  ScannerException("Congrats",
                                      "The ${vehicleController.text} has been checked out successfully."));
                            } on ScannerException catch (e) {
                              showScannerExceptionDialog(context, e);
                            }
                          },
                          child: Text(
                            'Exit',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 52,
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 18, left: 18),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade700),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50)),
                    overlayColor:
                        MaterialStateProperty.all(Colors.blue.shade600),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Scan QR Code',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
