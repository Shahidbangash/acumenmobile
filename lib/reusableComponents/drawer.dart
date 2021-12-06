import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: ListView(
        children: FirebaseAuth.instance.currentUser != null
            ? registeredUserListTile()
            : [
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
                      "Login to view Account",
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                // ),
                ListTile(
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

List<Widget> registeredUserListTile() {
  return [
    DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColorAndPrimaryButtonColor,
            primaryColorAndPrimaryButtonColor,
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
          "Welcome " +
              "${getCurrentUser()!.displayName ?? 'Username not provided'}",
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    ),
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.emailVerified) {
            return ListTile(
              leading: Icon(
                Icons.verified_user,
                color: Colors.green,
              ),
              title: Text("Email Verified"),
            );
          } else {
            return ListTile(
              leading: Icon(
                Icons.verified_user,
              ),
              title: Text("Verify Email"),
              onTap: () {
                FirebaseAuth.instance.currentUser!
                    .sendEmailVerification()
                    .then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "We have sent an email for verification",
                    ),
                  ));

                  FirebaseAuth.instance.currentUser!.reload();
                });
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
    ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text("Log out"),
      onTap: () {
        logOut();
      },
    ),
  ];
}
