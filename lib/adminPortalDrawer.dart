import 'package:e_m_s/adminProfile.dart';
import 'package:e_m_s/employeeAttendance.dart';
import 'package:flutter/material.dart';
import 'adminPortal.dart';
import 'homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/adminProfile.dart';
import 'package:e_m_s/allEmployeeAttendanceDetails.dart';
import 'package:e_m_s/allEmployeeAdvanceDetails.dart';
import 'package:e_m_s/allEmployeeLeaveDetails.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print('Not user');
    }
  }

//////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white60,
                    Colors.lightGreenAccent,
                    Colors.greenAccent
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.centerRight,
                ),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              // color: Colors.lightGreen[300],
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Admin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 30),
                      ),
                      width: 100,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   child: Text("${loggedInUser.email}"),
            // ),

            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminProfile()));
              },
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.present_to_all,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllEmployeeAttendance()));
              },
              title: Text(
                'Employee Attendance Details',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.payments_outlined,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdvanceDetails()));
              },
              title: Text(
                'Employee Advance Details',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaveDetails()));
              },
              title: Text(
                'Employee Leave Details',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 10,
                    color: Colors.lightGreenAccent,
                    splashColor: Colors.white,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
