import 'package:e_m_s/advanceApplicationDetailsEmployee.dart';
import 'package:flutter/material.dart';
import 'employeePortal.dart';
import 'homePage.dart';
import 'leaveApplicationDetailsEmployee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/employeeProfile.dart';
import 'package:e_m_s/attendanceDetailsEmployee.dart';

class EmployeeDrawer extends StatefulWidget {
  @override
  _EmployeeDrawerState createState() => _EmployeeDrawerState();
}

class _EmployeeDrawerState extends State<EmployeeDrawer> {
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
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightGreen,
                      Colors.blueGrey[200],
                      Colors.greenAccent,
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
                          'Employee',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Text(''),
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.person,
              //     color: Colors.lightGreen[800],
              //   ),
              //   onTap: () {
              //     print(loggedInUser.email);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => EmployeeProfile()));
              //   },
              //   title: Text(
              //     'Profile',
              //     style: TextStyle(
              //         fontSize: 20,
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              ListTile(
                leading: Icon(
                  Icons.present_to_all,
                  color: Colors.lightGreen[800],
                ),
                onTap: () {
                  print(loggedInUser.email);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendanceDetails()));
                },
                title: Text(
                  'Regular Attendance',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.file_copy,
                  color: Colors.lightGreen[800],
                ),
                onTap: () {
                  print(loggedInUser.email);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaveApplicationsDetails()));
                },
                title: Text(
                  'Leave Applications Details',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.file_copy,
                  color: Colors.lightGreen[800],
                ),
                onTap: () {
                  print(loggedInUser.email);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdvanceApplicationsDetails()));
                },
                title: Text(
                  'Advance Applications Details',
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
                    child: Container(
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
                          //New add
                          _auth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ),
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
