import 'dart:developer';

import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/TopBarContainer.dart';
import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  void initState() {
    super.initState();
    log("Date time is ${DateTime.now()}");
  }

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
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("history")
                              .where("userID", isEqualTo: getCurrentUser()!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: snapshot.data!.docs.map((e) {
                                  var date = e.get('date');
                                  DateTime dateTime = e.get('date');
                                  dateTime.toLocal();
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date"),
                                              Spacer(),
                                              Text(
                                                "${e.get("date")}",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("OverAll mode"),
                                              Spacer(),
                                              Text(
                                                "${e.get("mood")}",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ),
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
