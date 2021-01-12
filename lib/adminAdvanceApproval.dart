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
              DataCell(Text(doc.data()['Email'])),
              DataCell(Text(doc.data()['Amount'])),
              DataCell(Text(doc.data()['ApplyDate'])),
              DataCell(Text(doc.data()['ApplyTime'])),
              DataCell(Text(doc.data()['Reason'])),
              DataCell(IconButton(
                icon: doc.data()['isApproved']
                    ? Icon(
                        Icons.done_outline_sharp,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.pending,
                        color: Colors.red,
                      ),
                onPressed: () async {
                  await documentSnapshot
                      .data()
                      .update('isApproved', (value) => true);
                  print('approving');
                },
              )),
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
                        new DataColumn(label: Text('Email')),
                        new DataColumn(label: Text('Amount')),
                        new DataColumn(label: Text('Apply Date')),
                        new DataColumn(label: Text('Time')),
                        new DataColumn(label: Text('Reason')),
                        new DataColumn(label: Text(' ')),
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
            DataCell(Text(documentSnapshot.data()['Email'].toString())),
            DataCell(Text(documentSnapshot.data()['Amount'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyDate'].toString())),
            DataCell(Text(documentSnapshot.data()['ApplyTime'].toString())),
            DataCell(Text(documentSnapshot.data()['Reason'].toString())),
            DataCell(IconButton(
              icon: documentSnapshot.data()['isApproved']
                  ? Icon(
                      Icons.done_outline_sharp,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.pending,
                      color: Colors.red,
                    ),
              onPressed: () {
                bool approve = true;
                String employeeId = documentSnapshot.data()['Employeeid'];

                print(documentSnapshot.id);
                print(documentSnapshot.data()['Employeeid']);
                FirebaseFirestore.instance
                    .collection('Employee')
                    .doc(employeeId)
                    .collection('AdvanceApplication')
                    .doc(documentSnapshot.id)
                    .update({'isApproved': approve}).then((value) {
                  print('success');
                });

                //documentSnapshot.data()['isApproved'].update({});
                print('approving');
              },
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
                    .collection('AdvanceApplication')
                    .doc(documentSnapshot.id)
                    .delete();
              },
            ))
          ],
        );
      },
    ).toList();
    print('Data Row');
    return newList;
  }
}
