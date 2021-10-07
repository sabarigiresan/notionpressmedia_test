import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as Io;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var decodebyteimage;
  String? username = '';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('data')
        .doc('60Y3ujs9TloMGS8svV0q')
        .get()
        .then((value) {
      setState(() {
        username = value['name'];
        var userimage = value['image'];
        print("responsefromfirestore username:$username");
        print("responsefromfirestore userImage:$userimage");
        decodebyteimage = base64Decode(userimage);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username!,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              height: 200,
              child: Image.memory(
                decodebyteimage,
                fit: BoxFit.fill,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
