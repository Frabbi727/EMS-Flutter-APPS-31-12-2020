import 'package:flutter/material.dart';
import 'adminPortal.dart';
import 'package:flutter/material.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/adminPortal.dart';
import 'package:e_m_s/adminPortalDrawer.dart';

class AllEmployeeAttendance extends StatefulWidget {
  @override
  _AllEmployeeAttendanceState createState() => _AllEmployeeAttendanceState();
}

class _AllEmployeeAttendanceState extends State<AllEmployeeAttendance> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;
  String apv = 'aproved';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
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

  ///////////////////////////////////////

  Future populateTable() async {
    QuerySnapshot result =
        await FirebaseFirestore.instance.collectionGroup('Attendance').get();
    List<DocumentSnapshot> documents = result.docs;
    documents.forEach((doc) {
      List<DataRow> newList = result.docs.map(
        (DocumentSnapshot documentSnapshot) {
          // bool isApproved;
          print(documentSnapshot.id);
          DataRow(
            cells: [
              DataCell(Text(doc.data()['Email'])),
              DataCell(Text(doc.data()['AttendanceDate'])),
              DataCell(Text(doc.data()['AttendanceTime'])),
              DataCell(Text(doc.data()['AttendanceStatus'])),
            ],
          );
        },
      ).toList();
      return newList;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Employee Attendance',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: FutureBuilder(
          future: populateTable(),
          builder: (context, snapshot) {
            print('Future Builder 01');
            if (!snapshot.hasData) {
              print('Future Builder 02');
              return CircularProgressIndicator();
            } else
              print('Else');

            return ListView(
              addRepaintBoundaries: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('Attendance')
                      .snapshots(),

                  // ignore: missing_return
                  builder: (context, snapshot) {
                    print('Future Stream');
                    if (!snapshot.hasData) return new Text('Loading...');
                    return new DataTable(
                      columns: <DataColumn>[
                        new DataColumn(label: Text('Email')),
                        new DataColumn(label: Text('Date')),
                        new DataColumn(label: Text('Time')),
                        new DataColumn(label: Text('Status')),
                      ],
                      rows: _createRows(snapshot.data),
                    );
                    print('Data Table');
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
    List<DataRow> newList = snapshot.docs.map(
      (DocumentSnapshot documentSnapshot) {
        print('Data list');
        return new DataRow(
          cells: [
            DataCell(Text(documentSnapshot.data()['Email'].toString())),
            DataCell(
                Text(documentSnapshot.data()['AttendanceDate'].toString())),
            DataCell(
                Text(documentSnapshot.data()['AttendanceTime'].toString())),
            DataCell(
                Text(documentSnapshot.data()['AttendanceStatus'].toString())),
          ],
        );
      },
    ).toList();
    print('Data Row');
    return newList;
  }
}
