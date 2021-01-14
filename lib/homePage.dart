import 'package:e_m_s/adminPortal.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'createNewAccount.dart';
import 'employeePortal.dart';
import 'employeePortalDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
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
      print('User Not created');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('images/image1.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: (BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        )),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            if (!RegExp(
                                    '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[com]')
                                .hasMatch(value)) {
                              return "example@gmail.com";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            labelText: 'Enter Your Email',
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.lightGreen[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: (BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        )),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Minimum 6 Digits";
                            }
                            if (!RegExp('^[0-9]').hasMatch(value)) {
                              return 'Only Digits (0-9)';
                            }

                            return null;
                          },
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            labelText: 'Enter Your Password',
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.lightGreen[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        minWidth: 200,
                        color: Colors.lightGreenAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              final value = FirebaseFirestore.instance
                                  .collection('Employee')
                                  .doc(user.user.uid)
                                  .get()
                                  .then((value) {
                                if (value.exists) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EmployeePortal();
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AdminPortal();
                                      },
                                    ),
                                  );
                                }
                              });
                            } catch (e) {
                              print('having some Problem');
                            }
                          }
                        },
                        //on press
                        textColor: Colors.black,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),

                      //Login Ends here

                      MaterialButton(
                        minWidth: 200,
                        elevation: 10,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        color: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateNewAccount()));
                        },
                        textColor: Colors.black,
                        child: Text(
                          'Create new Account',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
