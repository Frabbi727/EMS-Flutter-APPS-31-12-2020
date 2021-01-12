import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:e_m_s/employeePortalDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllEmployeeTable extends StatefulWidget {
  @override
  _AllEmployeeTableState createState() => _AllEmployeeTableState();
}

class _AllEmployeeTableState extends State<AllEmployeeTable> {
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

//////////////////////////////////////////////////////////
  ////////////////////////////////////////////

  String gender;
  String designation;
  String name;
  String address;
  String dob;
  String phone;

  @override
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('Employee').snapshots())
      for (var employee in snapshot.docs) {
        print(employee.data());
      }
  }

  //////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Employee List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore.collection('Employee').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new DataTable(
                  columns: <DataColumn>[
                    new DataColumn(label: Text('Name')),
                    new DataColumn(label: Text('Phone')),
                    new DataColumn(label: Text('Email')),
                    new DataColumn(label: Text('Address')),
                    new DataColumn(label: Text('Gender')),
                    new DataColumn(label: Text('Dob')),
                    new DataColumn(label: Text('Designation')),
                    new DataColumn(label: Text('Remove')),
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
        DataCell(Text(documentSnapshot.data()['Name'].toString())),
        DataCell(Text(documentSnapshot.data()['Phone'].toString())),
        DataCell(Text(documentSnapshot.data()['Email'].toString())),
        DataCell(Text(documentSnapshot.data()['Address'].toString())),
        DataCell(Text(documentSnapshot.data()['Gender'].toString())),
        DataCell(Text(documentSnapshot.data()['Dob'].toString())),
        DataCell(Text(documentSnapshot.data()['Designation'].toString())),
        DataCell(IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Employee')
                .doc(documentSnapshot.id)
                .delete();
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
