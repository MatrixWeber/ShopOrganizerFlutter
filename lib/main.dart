import 'package:flutter/material.dart';
import 'package:shop_organizer/firebase/auth.dart';
import 'package:shop_organizer/firebase/auth_provider.dart';
import 'package:shop_organizer/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Shop Organizer',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.pink[50],
        ),
        home: RootPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
