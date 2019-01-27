import 'package:flutter/material.dart';

//importing MapView page
import './map_page.dart';

//Importing constants file
import './constants.dart' as constants;

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(constants.app_title),
          ),
          body: new MapPage(),),
    );
  }
}
