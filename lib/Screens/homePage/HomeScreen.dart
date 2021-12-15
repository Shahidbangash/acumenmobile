// import 'dart:html';
import 'dart:io';

import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/Screens/HistoryPage/ViewHistoryPage.dart';
import 'package:acumenmobile/Screens/NotificationScreen/ViewNotification.dart';
import 'package:acumenmobile/Screens/ProfileViewPage/ViewProfileScreen.dart';
import 'package:acumenmobile/Screens/homePage/MainScreenView.dart';
import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/confirmationDialog.dart';
import 'package:acumenmobile/reusableComponents/drawer.dart';
import 'package:acumenmobile/reusableComponents/rectanglePainter.dart';
import 'package:acumenmobile/reusableFunction/calculateSmile.dart';
import 'package:acumenmobile/reusableFunction/createImageStream.dart';
import 'package:acumenmobile/reusableFunction/detectFace.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

//  This is the Home Screen

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scafoldKey = GlobalKey<NavigatorState>();
  List<Widget> widgetOptions = [
    MainPageScreen(),
    ViewHistoryScreen(),
    ViewNotificationScreen(),
    ProfileView(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primaryColorAndPrimaryButtonColor,
      onRefresh: () async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
      child: Container(
        // color: background
        color: primaryColorAndPrimaryButtonColor,
        child: SafeArea(
          child: Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              backgroundColor: primaryColorAndPrimaryButtonColor,
            ),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              child: widgetOptions.elementAt(selectedIndex),
            ),
            // floatingActionButton: FloatingActionButton(
            //   // onPressed: () {
            //   //   showCustomDialog(
            //   //     context: context,
            //   //     buttonList: [
            //   //       Container(
            //   //         padding: const EdgeInsets.all(8.0),
            //   //         decoration: BoxDecoration(
            //   //             color: Colors.white,
            //   //             borderRadius:
            //   //                 const BorderRadius.all(Radius.circular(10.0))),
            //   //         child: Column(
            //   //           children: [
            //   //             InkWell(
            //   //               onTap: () {
            //   //                 pickImage(imageSource: ImageSource.gallery);
            //   //               },
            //   //               child: Container(
            //   //                 padding: const EdgeInsets.all(8.0),
            //   //                 child: Text("Pick Image from Gallery"),
            //   //               ),
            //   //             ),
            //   //             Divider(),
            //   //             InkWell(
            //   //               onTap: () {
            //   //                 pickImage(imageSource: ImageSource.camera);
            //   //               },
            //   //               child: Padding(
            //   //                 padding: const EdgeInsets.all(8.0),
            //   //                 child: Text("Pick Image From Camera"),
            //   //               ),
            //   //             ),
            //   //             Divider(),
            //   //             InkWell(
            //   //               onTap: () {
            //   //                 pickVideo();
            //   //               },
            //   //               child: Container(
            //   //                 padding: const EdgeInsets.all(8.0),
            //   //                 child: Text("Pick Video From Gallery"),
            //   //               ),
            //   //             ),
            //   //           ],
            //   //         ),
            //   //       ),
            //   //       SizedBox(
            //   //         height: 10,
            //   //       ),
            //   //     ],
            //   //   );
            //   // },
            //   backgroundColor: white,
            //   child: Icon(
            //     CupertinoIcons.add,
            //     color: black,
            //     size: 33,
            //   ), //icon inside button
            //   elevation: 33,
            // ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              enableFeedback: true,
              backgroundColor: primaryColorAndPrimaryButtonColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
                // Respond to item press.
              },
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(CupertinoIcons.home),
                ),
                BottomNavigationBarItem(
                  label: 'History',
                  icon: Icon(CupertinoIcons.hand_draw),
                ),
                BottomNavigationBarItem(
                  label: 'Notification',
                  icon: Icon(CupertinoIcons.bell),
                ),
                BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(CupertinoIcons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
