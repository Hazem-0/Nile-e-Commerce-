import 'dart:io';

import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/theme_states.dart';
import 'package:cx_final_project/block/cubit_state/user_data_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/snackBar.dart';
import 'package:cx_final_project/widgets/profile_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  Map<String, dynamic>? userData;
  String firstName = '';
  File? image;
  bool imageLoading = false;
  bool isLoading = false;
  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    // log('stopped here in profile screen');
    userData = BlocProvider.of<UserDataCubit>(context).userData;
    // log('profile here ' + userData.toString());

    RegExp regExp = RegExp(r'^\s*(\S+)', caseSensitive: false);
    Match? match = regExp.firstMatch(userData!['name']);
    firstName = match?.group(1) ?? "";
    String? imageURL;
    Map<String, Color> colors = context.watch<ThemeCubit>().colors;

    return BlocConsumer<UserDataCubit, UserDataStates>(
      listener: (context, state) {
        if (state is SetImageLoading) {
          imageLoading = true;
        }
        if (state is SetImageSuccess) {
          showCustomSnackBar(
            context,
            "Image updated",
            color: Colors.green,
          );
          imageLoading = false;
        }
        if (state is UserDataLoading) {
          isLoading = true;
        }
        if (state is FetechedDataSuccess) {
          // Navigator.pop(context);

          isLoading = false;
          // favoriteChoosed = BlocProvider.of<UserDataCubit>(context)
          //     .userData!['favoriteProducts'];
        }
        if (state is UpdatePasswordSuccess) {
          isLoading = false;
          showCustomSnackBar(context, "Updated password successfully!",
              color: Colors.green);
        }
        if (state is UpdatePasswordFailuer) {
          isLoading = false;
          showCustomSnackBar(context, "Can't change password ",
              color: Colors.red);
        }
        if (state is UpdatedDataSuccess) {
          showCustomSnackBar(
            context,
            "Data updated",
            color: Colors.green,
          );
          isLoading = false;
        }
        if (state is UpdateddDataFailuer) {
          showCustomSnackBar(
            context,
            "Data Failded",
            color: Colors.red,
          );
          isLoading = false;
        }
        if (state is UploadedImageSuccess) {
          isLoading = false;
          imageLoading = false;
          //imageURL = BlocProvider.of<UserDataCubit>(context).imageURL;
        }
        if (state is UploadedImageFailuer) {
          showCustomSnackBar(
            context,
            "Image uploaded failed",
            color: Colors.red,
          );
          imageLoading = false;
          isLoading = false;
        }
      },
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, ThemeStates>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: colors['bgColor'], //colors['bgColor'],
              child: Stack(
                children: [
                  Container(
                    height: height / 5,
                    width: width,
                    decoration: BoxDecoration(
                      color: colors['mainColor'],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(100, 30),
                        bottomRight: Radius.elliptical(100, 30),
                      ),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: height / 4.99,
                    child: Container(
                      height: 3 * height / 4, // Adjust the height as needed
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    child: const Icon(
                                      Icons.dark_mode,
                                      size: 33,
                                    ),
                                    backgroundColor: colors['mainColor'],
                                    foregroundColor: AppColors.offWhite,
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Dark Mode",
                                    style: TextStyle(
                                        color: colors['fontColor'],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Spacer(),
                                  BlocBuilder<ThemeCubit, ThemeStates>(
                                    builder: (context, state) {
                                      return CupertinoSwitch(
                                          value: BlocProvider.of<ThemeCubit>(
                                                      context)
                                                  .isDark ??
                                              false,
                                          onChanged: (value) {
                                            BlocProvider.of<ThemeCubit>(context)
                                                .toggleTheme(value);

                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         CurrentScreen(
                                            //       currentScreen:
                                            //           ProfileScreen(),
                                            //     ),
                                            //   ),
                                            // );
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              height: height / 30,
                            ),
                            ProfileButton(
                              colors: colors,
                              id: 0,
                              icon: const Icon(
                                Icons.person,
                                size: 30,
                              ),
                              name: "Name",
                              status: userData!['name'],
                              color: colors['mainColor']!,
                            ),
                            SizedBox(
                              child: const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              height: height / 30,
                            ),
                            ProfileButton(
                              colors: colors,
                              id: 1,
                              icon: const Icon(
                                Icons.phone,
                                size: 30,
                              ),
                              name: "Phone",
                              status: userData!['phone'],
                              color: colors['mainColor']!,
                            ),
                            SizedBox(
                              child: const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              height: height / 30,
                            ),
                            ProfileButton(
                              colors: colors,
                              id: 2,
                              icon: const Icon(
                                Icons.email,
                                size: 30,
                              ),
                              name: "Email",
                              status: userData!['email'],
                              color: colors['mainColor']!,
                            ),
                            SizedBox(
                              child: const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              height: height / 30,
                            ),
                            ProfileButton(
                              colors: colors,
                              id: 3,
                              icon: const Icon(
                                Icons.password,
                                size: 30,
                              ),
                              name: "Change password",
                              status: "******",
                              color: colors['mainColor']!,
                            ),
                            SizedBox(
                              child: const Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              height: height / 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 142,
                    top: 85,
                    // Icon(
                    //     Icons.person,
                    //     size: 120,
                    //   ),
                    child: InkWell(
                      onTap: () {
                        showImagegDialog(context);
                      },
                      child: ClipOval(
                        child: Container(
                          child: (imageLoading)
                              ? CircularProgressIndicator(
                                  color: AppColors.mainLightColor,
                                )
                              : (imageURL != null)
                                  ? Image.network(
                                      imageURL,
                                      fit: BoxFit.cover,
                                    )
                                  : (BlocProvider.of<UserDataCubit>(context)
                                              .userImage !=
                                          null)
                                      ? Image.file(
                                          BlocProvider.of<UserDataCubit>(
                                                  context)
                                              .userImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "assests/images/defaultProfiel.png",
                                          width: 50,
                                          height: 50,
                                        ),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black38,
                                offset: Offset(0, 0),
                              ),
                            ],
                            //image: DecorationImage(
                            //   image: AssetImage('assests/images/logo.png'),
                            //   fit: BoxFit.fill,
                            // ),
                            color: AppColors.offWhite,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: width / 3.5,
                    top: 20,
                    child: (isLoading)
                        ? Container(
                            width: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.offWhite,
                              ),
                            ),
                          )
                        : Text(
                            "Welcome ${firstName}",
                            style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Thunder",
                              color: AppColors.offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  // (isLoading)
                  //     ? Positioned(
                  //         left: 250,
                  //         height: 450,
                  //         child: Container(
                  //           width: 50,
                  //           height: 50,
                  //           child: CircularProgressIndicator(
                  //             color: AppColors.color2,
                  //           ),
                  //         ))
                  //     : Container(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  showImagegDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.offWhite,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.offWhite,
                ),
                child: TextButton(
                  onPressed: () {
                    BlocProvider.of<UserDataCubit>(context)
                        .deleteImageFromFirebase(
                      BlocProvider.of<LoginCubit>(context).userToken!,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "remove",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              )
            ],
            backgroundColor: Colors.transparent,
            content: Container(
                height: 50,
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.bgColor,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            AppColors.mainLightColor,
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<UserDataCubit>(context)
                              .pickImageFromCamera();

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "camera",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.bgLightColor,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            AppColors.mainLightColor,
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<UserDataCubit>(context)
                              .pickImageFromGallery();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
