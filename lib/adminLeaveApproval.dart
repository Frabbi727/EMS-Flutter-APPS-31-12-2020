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
import 'package:e_m_s/leaveApplicationDetailsEmployee.dart';

class LeaveApproval extends StatefulWidget {
  @override
  _LeaveApprovalState createState() => _LeaveApprovalState();
}

class _LeaveApprovalState extends State<LeaveApproval> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;

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

  ////////////////////

  Future populateTable() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('LeaveApplication')
        .get();
    List<DocumentSnapshot> documents = result.docs;
    documents.forEach((doc) {
      List<DataRow> newList = result.docs.map(
        (DocumentSnapshot documentSnapshot) {
          bool isApproved;
          print('Data list');
          print(documentSnapshot.id);
          DataRow(
            cells: [
              DataCell(Text(doc.data()['EmployeeName'])),
              DataCell(Text(doc.data()['Email'])),
              DataCell(Text(doc.data()['ApplyDate'])),
              DataCell(Text(doc.data()['ApplyTime'])),
              DataCell(Text(doc.data()['StartDate'])),
              DataCell(Text(doc.data()['EndDate'])),
              DataCell(Text(doc.data()['Reason'])),
              DataCell(
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  )),
                  ////Gender Go Here
                  child: DropdownButton(
                    elevation: 10,
                    onChanged: (val) {
                      print(val);
                      setState(() {});
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text('Approved'),
                        value: 'Approved',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Pending',
                        ),
                        value: 'Pending',
                      )
                    ],
                  ),
                ),
              ),
              DataCell(IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {},
              )),
            ],
          );
        },
      ).toList();
      return newList;
    });
    return true;
  }

//////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Leave Applications',
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
                      .collectionGroup('LeaveApplication')
                      .snapshots(),

                  // ignore: missing_return
                  builder: (context, snapshot) {
                    print('Future Stream');
                    if (!snapshot.hasData) return new Text('Loading...');
                    return new DataTable(
                      columns: <DataColumn>[
                        new DataColumn(label: Text('Employee Name')),
                        new DataColumn(label: Text('Email')),
                        new DataColumn(label: Text('Apply Date')),
                        new DataColumn(label: Text('Time')),
                        new DataColumn(label: Text('Start Date')),
                        new DataColumn(label: Text('End Date')),
                        new DataColumn(label: Text('Reason')),
                        new DataColumn(label: Text('Status')),
                        new DataColumn(label: Text(' ')),
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
            DataCell(Text(documentSnapshot.data()['EmployeeName'].toString())),
            DataCell(Text(documentSnapshot.data()['Email'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyDate'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyTime'].toString())),
            DataCell(Text(documentSnapshot.data()['StartDate'].toString())),
            DataCell(Text(documentSnapshot.data()['EndDate'].toString())),
            DataCell(Text(documentSnapshot.data()['Reason'].toString())),
            DataCell(DropdownButton(
              elevation: 10,
              hint: Text('${documentSnapshot.data()['isApproved']}'),
              onChanged: (val) {
                print(val);
                setState(() {});
              },
              items: [
                DropdownMenuItem(
                  child: Text(
                    'Approve',
                    style: TextStyle(color: Colors.green),
                  ),
                  value: 'Approve',
                  onTap: () async {
                    ////
                    String AdminName;
                    await FirebaseFirestore.instance
                        .collection('Admin')
                        .doc(loggedInUser.uid)
                        .get()
                        .then((value) {
                      AdminName = value.data()['Name'];
                      print('${value.data()['Name']}');
                    });

                    ////
                    String employeeId = documentSnapshot.data()['Employeeid'];
                    FirebaseFirestore.instance
                        .collection('Employee')
                        .doc(employeeId)
                        .collection('LeaveApplication')
                        .doc(documentSnapshot.id)
                        .update({
                      'isApproved': 'approved by: ${AdminName} '
                    }).then((value) {
                      print('success');
                    });
                  },
                ),
                DropdownMenuItem(
                  child: Text(
                    'Decline',
                    style: TextStyle(color: Colors.red),
                  ),
                  value: 'Decline',
                  onTap: () async {
                    ////
                    String AdminName;
                    await FirebaseFirestore.instance
                        .collection('Admin')
                        .doc(loggedInUser.uid)
                        .get()
                        .then((value) {
                      AdminName = value.data()['Name'];
                      print('${value.data()['Name']}');
                    });

                    ////
                    String employeeId = documentSnapshot.data()['Employeeid'];
                    FirebaseFirestore.instance
                        .collection('Employee')
                        .doc(employeeId)
                        .collection('LeaveApplication')
                        .doc(documentSnapshot.id)
                        .update({
                      'isApproved': 'declined by: ${AdminName}'
                    }).then((value) {
                      print('success');
                    });
                  },
                )
              ],
            )),
            DataCell(IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                String employeeId = documentSnapshot.data()['Employeeid'];
                FirebaseFirestore.instance
                    .collection('Employee')
                    .doc(employeeId)
                    .collection('LeaveApplication')
                    .doc(documentSnapshot.id)
                    .delete();
              },
            )),
          ],
        );
      },
    ).toList();
    print('Data Row');
    return newList;
  }
}
