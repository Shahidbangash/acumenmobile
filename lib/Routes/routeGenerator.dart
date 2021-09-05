import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/Screens/404Page/screenNotFound.dart';
import 'package:acumenmobile/Screens/forgotPasswordPage/forgotPasswordScreen.dart';
import 'package:acumenmobile/Screens/homePage/HomeScreen.dart';
import 'package:acumenmobile/Screens/loginPage/loginScreen.dart';
import 'package:acumenmobile/Screens/signupPage/signupScreen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case loginPageRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signupPageRoute:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case forgetPasswordPageRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

      default:
        return MaterialPageRoute(builder: (_) => PageNotFoundScreen());
    }
  }
}
