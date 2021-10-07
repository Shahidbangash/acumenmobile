import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/material.dart';

class TopBarDecoration extends StatelessWidget {
  final String? title;
  final Color? backgroundColor;
  final Widget widget;
  const TopBarDecoration({
    Key? key,
    required this.widget,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 60),
          // bottomRight: Radius.elliptical(100, 100),
          bottomRight: Radius.elliptical(50, 60),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey[400]!,
            offset: Offset(0, 3.5),
          )
        ],
        color: this.backgroundColor,
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: Text(
              this.title ?? "",
              style: TextStyle(
                fontFamily: "Angel",
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Color(0xFFB0F3CB),
          ),
          this.widget
        ],
      ),
    );
  }
}
