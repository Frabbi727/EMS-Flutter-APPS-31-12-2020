import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'employeePortalDrawer.dart';
import 'leaveApplicationForm.dart';
import 'advanceApplicationForm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/employeePortal.dart';

class AdvanceApplicationForm extends StatefulWidget {
  @override
  _AdvanceApplicationFormState createState() => _AdvanceApplicationFormState();
}

class _AdvanceApplicationFormState extends State<AdvanceApplicationForm> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;
  String amount;
  String reason;
  String applyDate;

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
      print('Fail');
    }
  }

//////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Advance Application Form'),
      ),
      backgroundColor: Colors.cyan,
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
                      amount = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      labelText: 'Advance Amount',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.money,
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
                        child: Text('Loan'),
                        value: 'Loan',
                      ),
                      // DropdownMenuItem(
                      //   child: Text('Family Program'),
                      //   value: 'Family Program',
                      // ),
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
                          borderRadius: BorderRadius.circular(30.0),
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
                          print(loggedInUser);
                          print(loggedInUser.email);
                          //Do something Here
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
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
                          print(amount);
                          print(reason);
                          print(applyDate);

                          // final newAP= _firestore
                          //      .collection('Employee')
                          //      .doc(loggedInUser.uid)
                          //      .collection('AdvanceApplication')
                          //      .add({
                          //    'Amount': amount,
                          //    'Reason': reason,
                          //    'ApplyDate': applyDate,
                          //  });
                          //
                          //  Navigator.push(
                          //      context,
                          //      MaterialPageRoute(
                          //          builder: (context) => EmployeePortal()));
                          try {
                            final newAP = _firestore
                                .collection('Employee')
                                .doc(loggedInUser.uid)
                                .collection('AdvanceApplication')
                                .add({
                              'Amount': amount,
                              'Reason': reason,
                              'ApplyDate': applyDate,
                            });

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EmployeePortal()));
                            if (newAP != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeePortal()));
                            }
                          } catch (e) {}
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
