import 'package:flutter/material.dart';
import 'package:keyur_01/sqlite_database/screens/userListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: UserListScreen(),
    );
  }
}
