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

class AdvanceApplicationsDetails extends StatefulWidget {
  @override
  _AdvanceApplicationsDetailsState createState() =>
      _AdvanceApplicationsDetailsState();
}

class _AdvanceApplicationsDetailsState
    extends State<AdvanceApplicationsDetails> {
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
        print(loggedInUser.uid);
      }
    } catch (e) {
      print('Not user');
    }
  }

//////////////////////////////////////////////////////////
  Widget bodyData() => DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text('Apply Date'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('Amount'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('Payment Date'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('ApprovedBy'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('Status'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
        ],
        rows: advanceDetails
            .map(
              (detail) => DataRow(
                cells: [
                  DataCell(
                    Text(detail.requestDate),
                  ),
                  DataCell(
                    Text(detail.amount),
                  ),
                  DataCell(
                    Text(detail.paymentDate),
                  ),
                  DataCell(
                    Text(detail.approvedBy),
                  ),
                  DataCell(
                    Text(detail.status),
                  ),
                ],
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Advance Details'),
        ),
        body: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
              children: [
                Container(
                  child: bodyData(),
                ),
              ],
            )
          ],
        ));
  }
}

class AdvanceDetails {
  var requestDate, amount, paymentDate, approvedBy;
  String status;
  AdvanceDetails(
      {this.requestDate,
      this.amount,
      this.paymentDate,
      this.approvedBy,
      this.status});
}

var advanceDetails = <AdvanceDetails>[
  AdvanceDetails(
      requestDate: '1/2/2020',
      amount: '300',
      paymentDate: '12/1/2020',
      approvedBy: 'NB',
      status: 'Rejected'),
  AdvanceDetails(
      requestDate: '1/2/2020',
      amount: '300',
      paymentDate: '12/1/2020',
      approvedBy: 'NB',
      status: 'Rejected'),
  AdvanceDetails(
      requestDate: '1/2/2020',
      amount: '300',
      paymentDate: '12/1/2020',
      approvedBy: 'NB',
      status: 'Rejected'),
];
