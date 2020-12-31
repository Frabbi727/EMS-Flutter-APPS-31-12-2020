import 'package:flutter/material.dart';
import 'adminPortal.dart';
import 'package:flutter/material.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  ////////////////////
  String amount;
  String applyDate;
  String reason;

  @override
  void messagesStream() async {
    ///////
  }

  ///////////////

//////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: SafeArea(
          child: Text(
            'Advance Applications',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          scrollDirection: Axis.horizontal,

          children: <Widget>[
            StreamBuilder(
              stream: _firestore.collection('Employee').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new DataTable(
                  columns: <DataColumn>[
                    // new DataColumn(
                    //   label: Text('Serial'),
                    // ),
                    new DataColumn(label: Text('Amount')),
                    new DataColumn(label: Text('Apply Date')),
                    new DataColumn(label: Text('Reason')),
                    // new DataColumn(label: Text('Address')),
                    // new DataColumn(label: Text('Gender')),
                    // new DataColumn(label: Text('Dob')),
                  ],
                  rows: _createRows(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return new DataRow(cells: [
        DataCell(Text(documentSnapshot.data()['Amount'].toString())),
        DataCell(Text(documentSnapshot.data()['ApplyDate'].toString())),
        DataCell(Text(documentSnapshot.data()['Reason'].toString())),
        // DataCell(Text(documentSnapshot.data()['Address'].toString())),
        // DataCell(Text(documentSnapshot.data()['Gender'].toString())),
        // DataCell(Text(documentSnapshot.data()['Dob'].toString())),
      ]);
    }).toList();
    return newList;
  }
}
