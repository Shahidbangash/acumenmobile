import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/TopBarContainer.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewHistoryScreen extends StatefulWidget {
  ViewHistoryScreen({Key? key}) : super(key: key);

  @override
  _ViewHistoryScreenState createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
          // direction: Axis.vertical,
          children: [
            Flexible(
              flex: 2,
              child: TopBarDecoration(
                backgroundColor: primaryColorAndPrimaryButtonColor,
                title: "History",
                widget: Container(),
              ),
            ),
            user != null
                ? Flexible(
                    flex: 7,
                    child: Text("You have No History Yet"),
                  )
                : Flexible(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You have No History yet",
                      ),
                    ),
                  ),
          ]),
    );
  }
}
