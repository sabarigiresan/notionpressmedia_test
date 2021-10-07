import 'dart:convert';
// import 'dart:html';
import 'dart:io' as Io;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notionpress_test/screens/profile_screen.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  @override
  _Welcome_ScreenState createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  TextEditingController _name = TextEditingController();

  File? _image;

  final picker = ImagePicker();
  var base64;
  Future getImageFromCamera() async {
    // var image = await ImagePicker().pickImage(source: ImageSource.camera);
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final bytes = await Io.File(pickedFile!.path).readAsBytes();
    base64 = base64Encode(bytes);
    print('image   $base64');
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await Io.File(pickedFile!.path).readAsBytes();
    base64 = base64Encode(bytes);
    print('image   $base64');
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.purple,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.file(
                              _image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(80)),
                            width: 150,
                            height: 150,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.purple,
                            ),
                          )),
                      SizedBox(height: 70),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.purple,
                          ),
                        ),
                        onPressed: () {
                          Map<String, dynamic> data = {
                            "name": _name.text,
                            "image": base64,
                          };
                          FirebaseFirestore.instance
                              .collection("data")
                              .add(data)
                              .then((value) => print(value.id));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Next Page",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Photo Library'),
                  onTap: () {
                    getImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
