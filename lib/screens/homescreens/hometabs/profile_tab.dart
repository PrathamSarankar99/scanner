import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/modals/database_modals/booking.dart';
import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/screens/homescreens/homescreen.dart';
import 'package:scanner/widgets/home_widgets/app_drawer.dart';
import 'package:scanner/widgets/inherited_widgets/scanner.dart';
import 'package:scanner/widgets/profile_widgets/profile_tile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key, @required this.changeTab}) : super(key: key);
  final Function(int) changeTab;
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Good ${getGreeting()}!',
                  style: GoogleFonts.montserrat(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  Employee.currentEmployee.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 35,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ProfileTile(
                title: 'Your Mail ID',
                content: Employee.currentEmployee.emailId,
              ),
              ProfileTile(
                title: 'Your Contact no.',
                content: Employee.currentEmployee.contactNumber,
              ),
              const Spacer(),
              Center(
                child: SvgPicture.asset(
                  'assets/graphics/working.svg',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          )),
    );
  }

  getGreeting() {
    DateTime datime = DateTime.now();
    if (datime.hour >= 0 && datime.hour <= 10) {
      return 'Morning';
    }
    if (datime.hour >= 11 && datime.hour <= 2) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}
