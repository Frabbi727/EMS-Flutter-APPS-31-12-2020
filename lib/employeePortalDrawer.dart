import 'package:e_m_s/advanceApplicationDetailsEmployee.dart';
import 'package:flutter/material.dart';
import 'employeePortal.dart';
import 'homePage.dart';
import 'leaveApplicationDetailsEmployee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/employeeProfile.dart';

class EmployeeDrawer extends StatefulWidget {
  @override
  _EmployeeDrawerState createState() => _EmployeeDrawerState();
}

class _EmployeeDrawerState extends State<EmployeeDrawer> {
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.lightGreen[300],
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/image1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                print(loggedInUser.email);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmployeeProfile()));
              },
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.file_copy,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                print(loggedInUser.email);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LeaveApplicationsDetails()));
              },
              title: Text(
                'Leave Applications Details',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.file_copy,
                color: Colors.lightGreen[800],
              ),
              onTap: () {
                print(loggedInUser.email);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdvanceApplicationsDetails()));
              },
              title: Text(
                'Advance Applications Details',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 10,
                    color: Colors.lightGreenAccent,
                    splashColor: Colors.white,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      //New add
                      _auth.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
