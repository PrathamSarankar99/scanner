import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/screens/homescreens/homescreen.dart';
import 'package:scanner/widgets/home_widgets/app_drawer.dart';
import 'package:scanner/widgets/home_widgets/history_tile.dart';
import 'package:scanner/widgets/inherited_widgets/scanner.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key key, @required this.changeTab}) : super(key: key);
  final Function(int) changeTab;
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  GlobalKey<ScaffoldState> scaffoldkey;
  @override
  void initState() {
    scaffoldkey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const HomeScreen();
            },
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: scaffoldkey,
        drawer: AppDrawer(changeTab: widget.changeTab),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              scaffoldkey.currentState.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
              child: Text(
                'History',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Colors.black.withOpacity(0.75),
                  fontWeight: FontWeight.w600,
                ),
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
                        padding: const EdgeInsets.only(top: 10),
                        children: streamSnapshot.data.docs
                            .map(
                              (e) => HistoryTile(
                                booking: Booking.fromMap(e.data(), e.id),
                              ),
                            )
                            .toList());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
