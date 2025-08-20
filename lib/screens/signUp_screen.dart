import 'package:cx_final_project/block/cubit/passwordSecure_cubit.dart';
import 'package:cx_final_project/block/cubit/register_cubit.dart';
import 'package:cx_final_project/block/cubit_state/passwordSecure_State.dart';
import 'package:cx_final_project/block/cubit_state/register_state.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/snackBar.dart';
import 'package:cx_final_project/screens/logIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  final Color color;
  SignUpScreen({super.key, required this.color});

  bool isLoading = false;
  bool isSecure = true;
  bool isSecureConfirm = true;
  final formkey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color secureColor = color;
    Color secureColorConfirm = color;

    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is Registersuccess) {
          isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
          showCustomSnackBar(context, "Welcome to join us",
              color: Colors.green);
        } else if (state is RegisterFailure) {
          isLoading = false;
          showCustomSnackBar(context, state.errorMessage, color: Colors.red);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            color: color,
          ),
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: AppColors.offWhite,
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
                bottom: 0,
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
                  child: SingleChildScrollView(
                    child:
                        BlocConsumer<PasswordsecureCubit, PasswordsecureState>(
                      listener: (context, state) {
                        if (state is PasswordsecureOff) {
                          if (state.confirm == 0) {
                            secureColor = AppColors.color4;
                            isSecure = false;
                          } else {
                            secureColorConfirm = AppColors.color4;
                            isSecureConfirm = false;
                          }
                        } else if (state is PasswordsecureOn) {
                          if (state.confirm == 0) {
                            secureColor = color;
                            isSecure = true;
                          } else {
                            secureColorConfirm = color;
                            isSecureConfirm = true;
                          }
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34,
                                      color: color),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Card(
                                  elevation: 1,
                                  child: TextFormField(
                                    // key: formkey,

                                    keyboardType: TextInputType.text,
                                    controller: name_controller,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    // controller: email_controller,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return "Please Enter your Name";

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Card(
                                  elevation: 1,
                                  child: TextFormField(
                                    // key: formkey,

                                    keyboardType: TextInputType.number,

                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      hintText: "Phone",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    controller: phone_controller,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return "Please Enter your phone";

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Card(
                                  elevation: 1,
                                  child: TextFormField(
                                    // key: formkey,

                                    keyboardType: TextInputType.emailAddress,

                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    controller: email_controller,
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
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Card(
                                  elevation: 1,
                                  child: TextFormField(
                                    // key: formkey,

                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: isSecure,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: secureColor,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<PasswordsecureCubit>(
                                                  context)
                                              .toggleState(isSecure, 0);
                                        },
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    controller: password_controller,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return "Please Enter your password";
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Card(
                                  elevation: 1,
                                  child: TextFormField(
                                    // key: formkey,

                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: isSecureConfirm,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: secureColorConfirm,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<PasswordsecureCubit>(
                                                  context)
                                              .toggleState(isSecureConfirm, 1);
                                        },
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      hintText: "Confirm password",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                    // controller: email_controller,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return "Please Enter your confirm password";
                                      else if (value.isNotEmpty &&
                                          value != password_controller.text) {
                                        return "Password is different";
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen())),
                                    child: const Text(
                                      "Aleardy have an accound?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen())),
                                    icon: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: color,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formkey.currentState!.validate()) {
                                      BlocProvider.of<RegisterCubit>(context)
                                          .registerUser(
                                              context: context,
                                              email: email_controller.text,
                                              password:
                                                  password_controller.text,
                                              name: name_controller.text,
                                              phone: phone_controller.text);
                                    }
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  style: ButtonStyle(
                                    fixedSize: WidgetStateProperty.all<Size>(
                                        Size(350, 50)),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(color),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            AppColors.bgLightColor),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
