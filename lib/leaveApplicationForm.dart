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
  DateTime startDate;
  DateTime endDate;
  String reason;
  String applyTime;
  String uploadDateStart;
  String uploadDateEnd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

/////////////Getting current User ////////////////
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
                    child: Text(
                      applyDate = 'Date: ${now.day}/${now.month}/${now.year} ',
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
                SizedBox(
                  height: 60,
                  width: 400,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: Text(
                      applyTime = 'Time: ${now.hour}:${now.minute}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                ///////////***********Date Picker Problem ******************/////////////////////
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Select Starting Date'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000))
                              .then((value) {
                            setState(() {
                              startDate = value;

                              uploadDateStart =
                                  "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year.toString()}";
                              print(startDate);
                            });
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        startDate == null
                            ? 'Nothing has been selected'
                            : '${startDate.day}/${startDate.month}/${startDate.year}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                ///////////////**********Start Date Picker***************///////////////

                //////////////************End DatePicker*****************//////////////
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Select End Date'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000))
                              .then((value) {
                            setState(() {
                              endDate = value;

                              uploadDateEnd =
                                  "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year.toString()}";
                              print(endDate);
                            });
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        endDate == null
                            ? 'Nothing has been selected'
                            : '${endDate.day}/${endDate.month}/${endDate.year}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                ///////////////**********End Date Picker***************///////////////

                SizedBox(
                  height: 20,
                ),

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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          print(loggedInUser.uid);
                          print(loggedInUser.email);

                          try {
                            final newLA = await _firestore
                                .collection('Employee')
                                .doc(loggedInUser.uid)
                                .collection('LeaveApplication')
                                .add({
                              'ApplyDate': applyDate,
                              'ApplyTime': applyTime,
                              'StartDate': uploadDateStart,
                              'EndDate': uploadDateEnd,
                              'Reason': reason,
                              'Email': loggedInUser.email,
                              'Employeeid': loggedInUser.uid,
                              'isApproved': false,
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
