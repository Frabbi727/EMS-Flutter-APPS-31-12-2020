import 'package:e_m_s/adminProfile.dart';
import 'package:flutter/material.dart';
import 'adminPortal.dart';
import 'homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_m_s/adminProfile.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminProfile()));
              },
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.file_copy,
            //     color: Colors.lightGreen[800],
            //   ),
            //   onLongPress: () {},
            //   title: Text(
            //     'Leave Applications',
            //     style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.file_copy,
            //     color: Colors.lightGreen[800],
            //   ),
            //   onLongPress: () {
            //     //Do some Work
            //   },
            //   title: Text(
            //     'Advance Applications',
            //     style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
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
