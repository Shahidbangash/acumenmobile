import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:flutter/cupertino.dart';

// This file will be used for common

BuildContext context = navigatorKey!.currentState!.context;

double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;

final String placeholerImageLink =
    "https://via.placeholder.com/300.png/"; // will use this as default image fir user
