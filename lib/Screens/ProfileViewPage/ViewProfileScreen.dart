import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/TopBarContainer.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: TopBarDecoration(
              title: "Profile Screen",
              backgroundColor: primaryColorAndPrimaryButtonColor,
            ),
          ),
          Flexible(
            flex: 7,
            child: TopBarDecoration(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
