import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/Theme/fontStyles.dart';
import 'package:acumenmobile/reusableComponents/customTextFormField.dart';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableComponents/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColorAndPrimaryButtonColor,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // auto space between item based on the height
            children: [
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
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: dropShadow,
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
                            "Reset Password",
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
                                text: "Send Reset Password",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                      email: emailController.text,
                                    )
                                        .then((value) {
                                      setState(() {
                                        loading = false;
                                        emailController.clear();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "We have sent an email with reset link",
                                        ),
                                      ));
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
                    navigatorKey!.currentState!.context,
                    signupPageRoute,
                  );
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
