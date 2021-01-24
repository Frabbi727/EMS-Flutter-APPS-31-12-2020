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

class AdvanceApproval extends StatefulWidget {
  @override
  _AdvanceApprovalState createState() => _AdvanceApprovalState();
}

class _AdvanceApprovalState extends State<AdvanceApproval> {
  //////////////////////////////////////////////////////
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;
  String password;
  String approved;
  String rejected;
  String status;

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

  ////////////////////

  Future populateTable() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('AdvanceApplication')
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
              DataCell(Text(doc.data()['Amount'])),
              DataCell(Text(doc.data()['ApplyDate'])),
              DataCell(Text(doc.data()['ApplyTime'])),
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
      backgroundColor: Colors.deepOrangeAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent[700],
        title: Text(
          'Advance Applications',
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
                      .collectionGroup('AdvanceApplication')
                      .snapshots(),

                  // ignore: missing_return
                  builder: (context, snapshot) {
                    print('Future Stream');
                    if (!snapshot.hasData) return new Text('Loading...');
                    return new DataTable(
                      columns: <DataColumn>[
                        new DataColumn(label: Text('Employee Name')),
                        new DataColumn(label: Text('Email')),
                        new DataColumn(label: Text('Amount')),
                        new DataColumn(label: Text('Apply Date')),
                        new DataColumn(label: Text('Time')),
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
            DataCell(Text(documentSnapshot.data()['Amount'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyDate'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyTime'].toString())),
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
                  child: Text('Approve'),
                  value: 'Approve',
                  onTap: () async {
                    String AdminName;
                    ////
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
                        .collection('AdvanceApplication')
                        .doc(documentSnapshot.id)
                        .update({
                      'isApproved': 'approved by: ${AdminName}'
                    }).then((value) {
                      print('success');
                    });
                  },
                ),
                DropdownMenuItem(
                  child: Text(
                    'Decline',
                  ),
                  value: 'Decline',
                  onTap: () async {
                    String AdminName;
                    ////
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
                        .collection('AdvanceApplication')
                        .doc(documentSnapshot.id)
                        .update({
                      'isApproved': 'declined by: ${AdminName} '
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
              onPressed: () async {
                String employeeId = documentSnapshot.data()['Employeeid'];
                FirebaseFirestore.instance
                    .collection('Employee')
                    .doc(employeeId)
                    .collection('AdvanceApplication')
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
