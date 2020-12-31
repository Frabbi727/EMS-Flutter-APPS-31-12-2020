import 'dart:io';
import 'package:e_m_s/employeePortal.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  _CreateNewAccountState createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  // bool _secureText;

  String email;
  String password;
  String gender;
  String designation;
  String name;
  String address;
  String dob;
  String phone;
  String Admin;
  String Employee;

  File _image;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        print('Picked');
      } else {
        print('Not Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Account'),
      ),
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.amberAccent,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _image == null
                                    ? MemoryImage(kTransparentImage)
                                    : FileImage(_image),
                                fit: BoxFit.fill),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      // obscureText: _secureText,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        hintStyle: TextStyle(color: Colors.black),
                        // prefixIcon: IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       _secureText = !_secureText;
                        //     });
                        //   },
                        //   icon: Icon(Icons.security),
                        // ),
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Name',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Phone',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.call,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    ////Gender Go Here
                    child: DropdownButton(
                      hint: Text(
                        'Gender',
                      ),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          this.gender = val;
                        });
                      },
                      value: this.gender,
                      items: [
                        DropdownMenuItem(
                          child: Text('Male'),
                          value: 'Male',
                        ),
                        DropdownMenuItem(
                          child: Text('Female'),
                          value: 'Female',
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      onChanged: (value) {
                        dob = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Dob',
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: TextField(
                      onChanged: (value) {
                        address = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        labelText: 'Address',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: (BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    )),
                    child: DropdownButton(
                      hint: Text(
                        'Designation',
                      ),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          this.designation = val;
                        });
                      },
                      value: this.designation,
                      items: [
                        DropdownMenuItem(
                          child: Text('Admin'),
                          value: 'Admin',
                        ),
                        DropdownMenuItem(
                          child: Text('Employee'),
                          value: 'Employee',
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 10,
                          color: Colors.lightGreenAccent,
                          splashColor: Colors.white,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            print(email);
                            print(password);
                            print(name);
                            print(phone);
                            print(address);
                            print(dob);
                            print(designation);

                            try {
                              var newUser = _auth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then(
                                    (newUser) => _firestore
                                        .collection('$designation')
                                        .doc(newUser.user.uid)
                                        .set(
                                      {
                                        'Name': name,
                                        'Gender': gender,
                                        'Phone': phone,
                                        'Dob': dob,
                                        'Address': address,
                                        'Email': email,
                                      },
                                    ),
                                  );

                              if (newUser != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }

                              print('Its good to go');
                            } catch (e) {
                              print('Its not working');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
