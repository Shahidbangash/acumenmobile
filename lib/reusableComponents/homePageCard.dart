import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  const HomePageCard({
    Key? key,
    required this.iconData,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: Axis.vertical,
        children: [
          Icon(
            this.iconData,
            size: 50,
            color: primaryColorAndPrimaryButtonColor,
          ),
          Text(
            this.title,
            style: TextStyle(
              color: primaryColorAndPrimaryButtonColor,
            ),
            textScaleFactor: 1.4,
          )
        ],
      ),
    );
  }
}
