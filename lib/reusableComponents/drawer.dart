import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColorAndPrimaryButtonColor,
                  primaryColorAndPrimaryButtonColor,
                  // primaryColorAndPrimaryButtonColor,
                  // const Color(0xFF334756),
                  // const Color(0xFF082032),
                  // const Color(0xFF082032),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.mirror,
              ),
              // color: Colors.blue,
            ),
            child: Center(
              child: Text(
                getCurrentUser() != null
                    ? "Welcome " +
                        "${getCurrentUser()!.displayName ?? 'Username not provided'}"
                    : "Login to view Account",
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
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
