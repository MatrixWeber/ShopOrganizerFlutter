import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_organizer/entities/user.dart';
// import 'package:image_picker_ui/image_picker_handler.dart';
import 'package:shop_organizer/firebase/auth.dart';
import 'firebase/auth_provider.dart';
import 'custom_functions.dart';
import 'firebase/cloud.dart';
import 'firebase/cloud_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  File _image;
  static const _RADIUS = 120.0;
  static const _PADDING = 6.0;
  static const _TF_EDGE = 12.0;
  static const _TF_SIZE = 20.0;
  String _email = 'Email';
  String _name = 'Name';
  String _firstName = 'First Name';
  int _phone = 0123456789;

  TextEditingController _nameInputController;
  TextEditingController _firstNameInputController;
  TextEditingController _emailInputController;
  TextEditingController _phoneInputController;

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
            _emailInputController.text = _email;
          })
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getEmail();
  }

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController();
    _nameInputController.text = _name;
    _firstNameInputController = TextEditingController();
    _firstNameInputController.text = _firstName;
    _emailInputController = TextEditingController();
    _phoneInputController = TextEditingController();
    _phoneInputController.text = _phone.toString();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _getNameFromText(name) {
    setState(() {
      _name = name;
    });
  }

  _getFirstNameFromText(firstName) {
    setState(() {
      _firstName = firstName;
    });
  }

  _getEmailFromText(email) {
    setState(() {
      _email = email;
    });
  }

  _getPhoneFromText(phone) {
    setState(() {
      _phone = phone;
    });
  }

  Future<void> _storeInDatabase() async {
    var _user = User()
      ..name = _name
      ..firstName = _firstName
      ..email = _email
      ..phone = _phone
      ..isAdmin = false
      ..isClient = false
      ..imageUrl = 'none';
    try {
      //final BaseCloud cloud = CloudProvider.of(context).cloud;
      Cloud cloud = Cloud();
      await cloud.add('users', _user.getMap());
      print('Signed in: ' + _user.name);
    } catch (e) {
      print('Error: $e');
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 10),
      ));
    }
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
      key: _scaffoldState,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
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
                padding: EdgeInsets.all(_PADDING),
              ),
              GestureDetector(
                onTap: () => _showChoiseDialog(context),
                child: _decideImageView(),
              ),
              Padding(
                padding: EdgeInsets.all(_PADDING),
              ),
              TextField(
                onSubmitted: (firstName) => _getFirstNameFromText(firstName),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(_TF_EDGE),
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
                controller: _firstNameInputController,
                style: TextStyle(fontSize: _TF_SIZE),
                keyboardType: TextInputType.text,
              ),
              Padding(
                padding: EdgeInsets.all(_PADDING),
              ),
              TextField(
                onSubmitted: (name) => _getNameFromText(name),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(_TF_EDGE),
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                controller: _nameInputController,
                style: TextStyle(fontSize: _TF_SIZE),
                keyboardType: TextInputType.text,
              ),
              Padding(
                padding: EdgeInsets.all(_PADDING),
              ),
              TextField(
                onSubmitted: (email) => _getEmailFromText(email),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(_TF_EDGE),
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                controller: _emailInputController,
                style: TextStyle(fontSize: _TF_SIZE),
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: EdgeInsets.all(_PADDING),
              ),
              TextField(
                onSubmitted: (phone) => _getPhoneFromText(phone),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(_TF_EDGE),
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
                controller: _phoneInputController,
                style: TextStyle(fontSize: _TF_SIZE),
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: EdgeInsets.all(_PADDING),
              ),
              RaisedButton(
                  child: Text('Next', style: TextStyle(fontSize: _TF_SIZE)),
                  onPressed: _storeInDatabase),
            ],
          ),
        ),
      ),
    );
  }
}
