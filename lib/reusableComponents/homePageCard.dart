import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(45),
        gradient: LinearGradient(
          colors: [
            Colors.white30,
            Colors.white,
          ],
        ),
      ),
      padding: EdgeInsets.all(1),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: Axis.horizontal,
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
