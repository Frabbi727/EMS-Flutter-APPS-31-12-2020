import 'package:flutter/material.dart';
import 'employeePortalDrawer.dart';
import 'employeePortal.dart';
import 'package:e_m_s/advanceApplicationDetailsEmployee.dart';
import 'package:flutter/material.dart';
import 'employeePortal.dart';
import 'homePage.dart';
import 'leaveApplicationDetailsEmployee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/employeeProfile.dart';

class AttendanceDetails extends StatefulWidget {
  @override
  _AttendanceDetailsState createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
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
    messagesStream();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.uid);
      }
    } catch (e) {
      print('Not user');
    }
    return loggedInUser.uid;
  }

//////////////////////////////////////////////////////////
  @override
  messagesStream() async {
    await for (var snapshot in _firestore
        .collection('Employee')
        .doc(loggedInUser.uid)
        .collection('AdvanceApplication')
        .snapshots())
      for (var advanceApplication in snapshot.docs) {
        print(advanceApplication.data());
      }
  }

//////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Regular Attendance Details',
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
                        .collection('Attendance')
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return new Text('Loading...');
                      return new DataTable(
                        columns: <DataColumn>[
                          // new DataColumn(
                          //   label: Text('Serial'),
                          // ),
                          new DataColumn(label: Text('Name')),
                          new DataColumn(label: Text('Date')),
                          new DataColumn(label: Text('Time')),
                          new DataColumn(label: Text('Status')),
                          new DataColumn(label: Text(' ')),
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
        DataCell(Text(documentSnapshot.data()['EmployeeName'].toString())),
        DataCell(Text(documentSnapshot.data()['AttendanceDate'].toString())),
        DataCell(Text(documentSnapshot.data()['AttendanceTime'].toString())),
        DataCell(Text(documentSnapshot.data()['AttendanceStatus'].toString())),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              _firestore
                  .collection('Employee')
                  .doc(loggedInUser.uid)
                  .collection('Attendance')
                  .doc(documentSnapshot.id)
                  .delete();
            },
          ),
        )
      ]);
    }).toList();
    return newList;
  }
}
