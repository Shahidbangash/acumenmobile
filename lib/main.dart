import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/Theme/appTheme.dart';
import 'package:flutter/material.dart';

import 'Routes/routeGenerator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accumen FYP Mobile',
      theme:
          appTheme, // this theme can be customized inside theme folder .. check out apptheme.dart for customization
      onGenerateRoute: CustomRouter.generatedRoute,
      initialRoute: homePageRoute, // iniitaly home page will be shown
    );
  }
}
