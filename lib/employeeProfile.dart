import 'package:e_m_s/advanceApplicationDetailsEmployee.dart';
import 'package:flutter/material.dart';
import 'employeePortal.dart';
import 'homePage.dart';
import 'leaveApplicationDetailsEmployee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'employeePortalDrawer.dart';

class EmployeeProfile extends StatefulWidget {
  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
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
    getInformation();
  }

  Future getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        return loggedInUser.uid;
      }
    } catch (e) {
      print('Not user');
    }
    return getInformation();
  }

//////////////////////////////////////////////////////////

  Future getInformation() async {
    return await _firestore.collection('Employee').doc(loggedInUser.uid).get();
  }

//////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: FutureBuilder(
          future: getCurrentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else
              return ListView(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                scrollDirection: Axis.horizontal,

                children: <Widget>[
                  StreamBuilder(
                    stream: _firestore
                        .collection('Employee')
                        .doc(loggedInUser.uid)
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return new Text('Loading...');
                      return new DataTable(
                        columns: <DataColumn>[
                          // new DataColumn(
                          //   label: Text('Serial'),
                          // ),
                          // new DataColumn(label: Text('Name')),
                          // new DataColumn(label: Text('Phone')),
                          // new DataColumn(label: Text('Email')),
                          // new DataColumn(label: Text('Dob')),
                          // new DataColumn(label: Text('Phone')),
                          // new DataColumn(label: Text('Address')),
                        ],
                        rows: _createRows(snapshot.data),
                      );
                    },
                  ),
                ],
              );
          },
        ),
      ),
    );
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return new DataRow(cells: [
        // DataCell(Text(documentSnapshot.data()['Name'].toString())),
        // DataCell(Text(documentSnapshot.data()['Phone'].toString())),
        // DataCell(Text(documentSnapshot.data()['Email'].toString())),
        // DataCell(Text(documentSnapshot.data()['Dob'].toString())),
        // DataCell(Text(documentSnapshot.data()['Phone'].toString())),
        // DataCell(Text(documentSnapshot.data()['Address'].toString())),
      ]);
    }).toList();
    return newList;
  }
}
