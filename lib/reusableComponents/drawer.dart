import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
