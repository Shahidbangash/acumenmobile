import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(getCurrentUser() != null
                  ? getCurrentUser()!.email ?? "email not provided"
                  : "Login to view Account"),
            ),
            // ),
            getCurrentUser() != null
                ? ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Log out"),
                    onTap: () {
                      logOut();
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.login),
                    title: Text("Log in"),
                    onTap: () {
                      goToLoginScreen();
                    },
                  ),
          ],
        ),
      ),
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
