import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/screens/logIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ForgetpasswordScreen extends StatelessWidget {
  ForgetpasswordScreen({super.key, required this.color});
  final Color color;
  final formkey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
      body: Stack(children: [
        Container(
          width: width,
          height: height,
          color: color,
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.color4,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.elliptical(200, 250),
                    bottomLeft: Radius.elliptical(170, 300))),
            width: width,
            height: height,
          ),
        ),
        Positioned(
          bottom: 20,
          top: 20,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.elliptical(200, 300),
                    bottomLeft: Radius.elliptical(200, 300))),
            width: width,
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      color,
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(AppColors.offWhite),
                  ),
                ),
                SizedBox(
                  height: height / 7,
                ),
                const Text(
                  "Please, enter your email address. You will recive\nto create a new password via email.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: height / 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Card(
                            elevation: 1,
                            child: TextFormField(
                              controller: email_controller,
                              keyboardType: TextInputType.emailAddress,

                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              // controller: email_controller,
                              validator: (String? value) {
                                if (value!.isEmpty)
                                  return "Please Enter your email";
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 12,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                Size(300, 50),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(color),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.offWhite),
                            ),
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                await BlocProvider.of<LoginCubit>(context)
                                    .sendPasswordResetLink(
                                        email_controller.text);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              }
                            },
                            child: Text('Send')),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
