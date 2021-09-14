import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner/modals/database_modals/employee.dart';
import 'package:scanner/modals/database_modals/parking_area.dart';
import 'package:scanner/screens/authscreens/authtabs/logintab.dart';
import 'package:scanner/screens/authscreens/authtabs/otptab.dart';
import 'package:scanner/screens/homescreens/homescreen.dart';
import 'package:scanner/utils/helpers/toast_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isOTPsent;
  bool issending;
  String verificationId;
  String phoneNo;
  int forceResendingToken;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  void initState() {
    isOTPsent = false;
    issending = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPsent
        ? OTPTab(
            onPop: loadBack,
            phoneNo: phoneNo,
            verifyOtp: verifyOTP,
          )
        : LoginTab(
            onOtpRequest: sendOTP,
            isSending: issending,
          );
  }

  loadBack() {
    setState(() {
      issending = false;
      isOTPsent = false;
    });
  }

  verifyOTP(String otp) async {
    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((userCredential) async {
        Employee.currentEmployee = await Employee.current();
        print('The employee id is ${Employee.currentEmployee.id}');
        ParkingArea.currentArea =
            await ParkingArea.byId(Employee.currentEmployee.parkingAreaId);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
          ),
        );
      });
    } on FirebaseAuthException catch (error) {
      showCodeToast(error.code);
    }
  }

  sendOTP(String phoneNo) {
    setState(() {
      issending = true;
      this.phoneNo = phoneNo;
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        forceResendingToken: forceResendingToken,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          setState(() {
            issending = false;
            isOTPsent = false;
          });
          showCodeToast(error.code);
        },
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            isOTPsent = true;
            this.verificationId = verificationId;
            this.forceResendingToken = forceResendingToken;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    });
  }
}
