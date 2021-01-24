import 'package:e_m_s/adminLeaveApproval.dart';
import 'package:e_m_s/allEmployeeTableDetailsForAdmin.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'employeePortal.dart';
import 'adminPortalDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminAdvanceApproval.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/allEmployeeTableDetailsForAdmin.dart';
import 'package:e_m_s/adminProfile.dart';
import 'adminAdvanceApproval.dart';
import 'package:e_m_s/adminLeaveApproval.dart';

class AdminPortal extends StatefulWidget {
  @override
  _AdminPortalState createState() => _AdminPortalState();
}

class _AdminPortalState extends State<AdminPortal> {
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
/////////TO SEE THE ALL EMPLOYEE DETAILS////////////
  void getInformation() async {
    final Employee = await _firestore.collection('Employee').get();

    for (var employee in Employee.docs) {
      print(employee.data());
    }
  }

//////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(''),
      ),
      drawer: AdminDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
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
                          color: Colors.deepOrangeAccent[100],
                          child: Text(
                            'Advance Applications',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            print(loggedInUser.email);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdvanceApproval()));
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
                          color: Colors.lightGreenAccent[100],
                          child: Text(
                            'Leave Applications',
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
                                    builder: (context) => LeaveApproval()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: 350,
                        child: Container(
                          child: RaisedButton(
                            elevation: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.blueGrey[200],
                            child: Text(
                              'Employee Details',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              getInformation();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllEmployeeTable()));
                            },
                          ),
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
