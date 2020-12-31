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

class LeaveApplicationsDetails extends StatefulWidget {
  @override
  _LeaveApplicationsDetailsState createState() =>
      _LeaveApplicationsDetailsState();
}

class _LeaveApplicationsDetailsState extends State<LeaveApplicationsDetails> {
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
        onSelectAll: (b) {},
        sortColumnIndex: 2,
        sortAscending: true,
        columns: <DataColumn>[
          DataColumn(
            label: Text('Apply Date'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                leaveDetails.sort((a, b) => a.applyDate.compareTo(b.applyDate));
              });
            },
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('Approved Date'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('ApprovedBy'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                leaveDetails
                    .sort((a, b) => a.approvedBy.compareTo(b.approvedBy));
              });
            },
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('Start Date'),
            numeric: false,
            onSort: (index, bool) {},
            tooltip: 'To display Start Date',
          ),
          DataColumn(
            label: Text('End Date'),
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
        rows: leaveDetails
            .map(
              (detail) => DataRow(
                cells: [
                  DataCell(
                    Text(detail.applyDate),
                    onTap: () {
                      print('Selected ${detail.applyDate}');
                    },
                  ),
                  DataCell(
                    Text(detail.approvedDate),
                  ),
                  DataCell(
                    Text(detail.approvedBy),
                  ),
                  DataCell(
                    Text(detail.starDate),
                  ),
                  DataCell(
                    Text(detail.endDate),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Leave Details'),
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
      ),
    );
  }
}

class LeaveDetails {
  var starDate, endDate, applyDate, approvedDate;
  String approvedBy, status;
  LeaveDetails(
      {this.starDate,
      this.endDate,
      this.applyDate,
      this.approvedDate,
      this.approvedBy,
      this.status});
}

var leaveDetails = <LeaveDetails>[
  LeaveDetails(
      starDate: '1/2/2020',
      endDate: '5/2/2020',
      applyDate: '12/1/2020',
      approvedDate: '30/1/2020',
      approvedBy: 'NB',
      status: 'Rejected'),
  LeaveDetails(
      starDate: '1/2/2020',
      endDate: '5/2/2020',
      applyDate: '13/1/2020',
      approvedDate: '30/1/2020',
      approvedBy: 'MI',
      status: 'Approved'),
  LeaveDetails(
      starDate: '1/2/2020',
      endDate: '5/2/2020',
      applyDate: '14/1/2020',
      approvedDate: '30/1/2020',
      approvedBy: 'NB',
      status: 'Rejected'),
];
