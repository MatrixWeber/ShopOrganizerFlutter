import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_ui/image_picker_handler.dart';
import 'package:shop_organizer/firebase/auth.dart';
import 'firebase/auth_provider.dart';
import 'custom_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  static const _RADIUS = 120.0;
  var _email = 'Email';
  var _name = 'Name';

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _getEmail() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
          setState(() {
            _email = currentUser.email.toString();
          })
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getEmail();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _openFotoSource(BuildContext context, ImageSource source) async {
    var picture = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose the Foto source',
                style: textStyle(fontSize: 24.0, color: Colors.black),
                textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Galery',
                      style: textStyle(fontSize: 21.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => _openFotoSource(context, ImageSource.gallery),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Camera',
                        style: textStyle(fontSize: 21.0, color: Colors.black),
                        textAlign: TextAlign.center),
                    onTap: () => _openFotoSource(context, ImageSource.camera),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _ifImageNotSet() {
    return Stack(
      children: <Widget>[
        Center(
          child: CircleAvatar(
            radius: _RADIUS,
            backgroundColor: const Color(0xFF778899),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/my_great_logo.png',
            scale: 0.35,
          ),
        ),
      ],
    );
  }

  Widget _ifImageWasSet() {
    return Container(
      height: 240.0,
      width: 240.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: ExactAssetImage(_image.path),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.red, width: 5.0),
        borderRadius: BorderRadius.all(const Radius.circular(_RADIUS)),
      ),
    );
  }

  Widget _decideImageView() {
    return _image == null ? _ifImageNotSet() : _ifImageWasSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Your Profile',
                style: textStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            GestureDetector(
              onTap: () => _showChoiseDialog(context),
              child: _decideImageView(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: _name,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: _email,
              ),
            )
          ],
        ),
      ),
    );
  }
}
