import 'package:flutter/material.dart';
import 'employeePortal.dart';
import 'employeePortalDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;
  String applyDate;
  String startDate;
  String endDate;
  String reason;

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
        print(loggedInUser.uid);
        print(loggedInUser.email);
      }
    } catch (e) {
      print(loggedInUser);
    }
  }

//////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Leave Application Form'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 400,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    // child: TextField(
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     fillColor: Colors.white,
                    //     labelText: 'Start Date',
                    //     hintStyle: TextStyle(color: Colors.black),
                    //     prefixIcon: Icon(
                    //       Icons.date_range,
                    //       color: Colors.lightGreen[800],
                    //     ),
                    //   ),
                    // ),
                    child: Text(
                      applyDate =
                          'Apply Date :${now.day}/${now.month}/${now.year} Time: ${now.hour}/${now.minute}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  )),
                  child: TextField(
                    onChanged: (value) {
                      startDate = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      labelText: ' Start Date ',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.date_range_outlined,
                        color: Colors.lightGreen[800],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  )),
                  child: TextField(
                    onChanged: (value) {
                      endDate = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      labelText: 'End Date',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.date_range_rounded,
                        color: Colors.lightGreen[800],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   decoration: (BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(30),
                //   )),
                //   child: TextField(
                //     onChanged: (value) {
                //       reason = value;
                //     },
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       fillColor: Colors.white,
                //       labelText: ' Reason ',
                //       hintStyle: TextStyle(color: Colors.black),
                //       prefixIcon: Icon(
                //         Icons.text_fields,
                //         color: Colors.lightGreen[800],
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  alignment: Alignment.center,
                  decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  )),
                  child: DropdownButton(
                    hint: Text(
                      'Reason',
                    ),
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        this.reason = val;
                      });
                    },
                    value: this.reason,
                    items: [
                      DropdownMenuItem(
                        child: Text('Sick'),
                        value: 'Sick',
                      ),
                      DropdownMenuItem(
                        child: Text('Family Program'),
                        value: 'Family Program',
                      ),
                      DropdownMenuItem(
                        child: Text('Others'),
                        value: 'Others',
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
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
                          'Save As Draft',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          //Do something Here
                        },
                      ),
                    ),
                    SizedBox(
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
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          print(loggedInUser.uid);
                          print(loggedInUser.email);
                          // var newLA= await _firestore
                          //      .collection('Employee')
                          //      .doc(loggedInUser.uid)
                          //      .collection('LeaveApplication')
                          //      .add({
                          //    'ApplyDate': applyDate,
                          //    'StartDate': startDate,
                          //    'EndDate': endDate,
                          //    'Reason': reason,
                          //  });
                          //  Navigator.push(
                          //      context,
                          //      MaterialPageRoute(
                          //          builder: (context) => EmployeePortal()));
                          try {
                            final newLA = await _firestore
                                .collection('Employee')
                                .doc(loggedInUser.uid)
                                .collection('LeaveApplication')
                                .add({
                              'ApplyDate': applyDate,
                              'StartDate': startDate,
                              'EndDate': endDate,
                              'Reason': reason,
                            });
                            if (newLA != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeePortal()));
                            }
                          } catch (e) {
                            print('Empty Fields');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
