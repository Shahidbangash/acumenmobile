import 'package:flutter/material.dart';

//  This is the Home Screen

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: To Get Started remove this widget and write your own code here
            Center(
              child: Text("Welcome To Accument FYP"),
            ),
          ],
        ),
      ),
    );
  }
}
