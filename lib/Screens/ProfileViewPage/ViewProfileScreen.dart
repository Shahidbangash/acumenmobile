import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/TopBarContainer.dart';
import 'package:acumenmobile/reusableComponents/customTextFormField.dart';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableFunction/uploadImageFirebase.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController nameController = TextEditingController();
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.white24,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 3,
            child: TopBarDecoration(
              title: "Profile Screen",
              backgroundColor: primaryColorAndPrimaryButtonColor,
              widget: user != null
                  ? InkWell(
                      onTap: () {
                        ImagePicker.platform
                            .pickImage(source: ImageSource.gallery)
                            .then((value) async {
                          await uploadImagetFirebase(value!.path)
                              .then((value) async {
                            if (value != null) {
                              await FirebaseAuth.instance.currentUser!
                                  .updatePhotoURL(value);
                              FirebaseAuth.instance.currentUser!.reload();
                              setState(() {});
                            }
                          });
                        });
                      },
                      child: Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: StreamBuilder<User?>(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  return Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      snapshot.data!.photoURL != null
                                          ? snapshot.data!.photoURL.toString()
                                          : placeholerImageLink,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
          user != null
              ? Flexible(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey[400]!,
                            offset: Offset(0, 3.5),
                          )
                        ],

                        // elevation: 12,
                      ),
                      child: Form(
                        key: formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textScaleFactor: 1.4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormFieldCustom(
                                controller: nameController,
                                validator: (p0) {
                                  if (p0!.isEmpty) {
                                    return " Please Enter Username";
                                  } else {
                                    return null;
                                  }
                                },
                                hintText: user!.displayName ??
                                    "Update User name here",
                              ),
                            ),
                            loading
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : PrimaryButton(
                                    text: "Update Profile",
                                    onTap: () async {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await FirebaseAuth.instance.currentUser!
                                            .updateDisplayName(
                                                nameController.text)
                                            .then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                        }).catchError((onError) {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Flexible(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You are not logged yet",
                    ),
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
