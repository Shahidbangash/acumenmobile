import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/Theme/fontStyles.dart';
import 'package:acumenmobile/reusableComponents/customTextFormField.dart';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableComponents/validator.dart';
import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback?
      afterSignInFunction; // this function will be used if user login is appeared after transactionn.. we will call
  // this function after sign in to continue transaction.
  LoginScreen({Key? key, this.afterSignInFunction}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

// Write Code for login Screen here
class LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<
      FormState>(); // this key will used in form for validation and form reset

  TextEditingController nameController =
      TextEditingController(); //Creates a controller for an editable text field.
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColorAndPrimaryButtonColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // auto space between item based on the height
            children: [
              // Center(
              //   child: InkWell(
              //     onTap: () {
              //       navigatorKey!.currentState!.pushNamedAndRemoveUntil(
              //           signupPageRoute, (route) => false);
              //     },
              //     child: SizedBox(
              //       width: 100,
              //       height: 100,
              //       child: SvgPicture.asset(
              //         "assets/Icons/098-sign in.svg",
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: Container(
                  width: size.width *
                      0.87, // total width = 428 , sign form width = 380 .. 380/428 * 100 will gives us 87 percent..
                  // we can use this calculation to make it responsive for all different devices width.
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 48,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 500,
                        color: CupertinoColors.black,
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey, // this key will tell the state of form,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Sign in",
                            style: signupHeadingTextStyle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4.0, top: 24),
                          child: Text(
                            'Email',
                            style: signupFormLabelStyle,
                          ),
                        ),
                        TextFormFieldCustom(
                          validator: (email) {
                            return isValidEmail(
                              email: email.toString(),
                            )
                                ? null
                                : "Please enter valid email";
                          },
                          controller: emailController,
                          keyboardType: TextInputType.visiblePassword,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 4.0, top: 24),
                          child: Text(
                            'Password',
                            style: signupFormLabelStyle,
                          ),
                        ),
                        // password field starts here
                        TextFormFieldCustom(
                          validator: (password) {
                            if (password!.isEmpty) {
                              return "Please enter password";
                            }
                          },
                          controller: passwordController,
                          obscureText: true, // this will hide text from user
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        loading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor:
                                      primaryColorAndPrimaryButtonColor,
                                )),
                              )
                            : PrimaryButton(
                                text: "Sign In",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    login(
                                            email: emailController.text,
                                            password: passwordController.text)
                                        .then((value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      print("Value is $value");
                                    });
                                  } else {
                                    // show user an error message
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pop(); // remove this screen to avoid any route count issue .. as we might have fixed pop in other process
                  // navigatorKey.currentState.context
                  Navigator.pushNamed(
                      navigatorKey!.currentState!.context, signupPageRoute);
                },
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'No Account ? ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Signup',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColorAndPrimaryButtonColor,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
