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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
      ),
      drawer: AdminDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 200,
              color: Colors.cyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      height: 100,
                      width: 150,
                      child: RaisedButton(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.lightGreenAccent,
                        splashColor: Colors.lightGreenAccent[100],
                        child: Text(
                          'Advance Applications',
                          style: TextStyle(
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
                  ),
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: Container(
                      child: RaisedButton(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.lightGreenAccent,
                        splashColor: Colors.lightGreenAccent[100],
                        child: Text(
                          'Leave Applications',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             AdminPortal()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: 150,
            child: Container(
              child: RaisedButton(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.lightGreenAccent,
                splashColor: Colors.lightGreenAccent[100],
                child: Text(
                  'All Employee Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  getInformation();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllEmployeeTable()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
