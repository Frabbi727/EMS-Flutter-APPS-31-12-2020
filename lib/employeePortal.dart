import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'employeePortalDrawer.dart';
import 'leaveApplicationForm.dart';
import 'advanceApplicationForm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/employeeAttendance.dart';

class EmployeePortal extends StatefulWidget {
  @override
  _EmployeePortalState createState() => _EmployeePortalState();
}

class _EmployeePortalState extends State<EmployeePortal> {
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
    return Scaffold(
      backgroundColor: Colors.teal[700],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(''),
      ),
      drawer: EmployeeDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal,
                      Colors.blueAccent[100],
                      Colors.greenAccent
                    ],
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  // color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                        width: 350,
                        child: RaisedButton(
                          elevation: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.lightGreen[200],
                          child: Text(
                            'Daily Attendance',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmployeeAttendance()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: 350,
                        child: RaisedButton(
                          elevation: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.orangeAccent[100],
                          child: Text(
                            'Advance Application From',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdvanceApplicationForm()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: 350,
                        child: RaisedButton(
                          elevation: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.cyan[200],
                          child: Text(
                            'Leave Application From',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LeaveApplicationForm()));
                          },
                        ),
                      ),
                    ],
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
