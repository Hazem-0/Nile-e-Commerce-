import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/block/cubit/passwordSecure_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/login_state.dart';
import 'package:cx_final_project/block/cubit_state/passwordSecure_State.dart';
import 'package:cx_final_project/info/api_constants.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/snackBar.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/screens/current_screen.dart';
import 'package:cx_final_project/screens/forgetPassword-screen.dart';
import 'package:cx_final_project/screens/home.dart';
import 'package:cx_final_project/screens/signUp_screen.dart';
import 'package:cx_final_project/services/news_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  // Map<String, dynamic>? fetchedUserData;
  Future<List<Product>>? futureProducts;
  getProducts() async {
    return await futureProducts;
  }

  LoginScreen({super.key});
  bool isLoading = false;
  bool isSecure = true;
  Color? secureColor;
  final formkey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String, Color> colors = BlocProvider.of<ThemeCubit>(context).colors;
    secureColor = colors['mainColor'];
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          BlocProvider.of<UserDataCubit>(context).fetchUserData();
          BlocProvider.of<UserDataCubit>(context)
              .fetchProducts(context, getProducts());
          // BlocProvider.of<UserDataCubit>(context).fetchProducts(context);
          // favoriteChoosed =
          //     BlocProvider.of<UserDataCubit>(context).favoriteProducts??favoriteChoosed;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CurrentScreen(
                        currentScreen: HomeScreen(
                          colors: colors,
                        ),
                      )));
          showCustomSnackBar(context, "Logged In", color: Colors.green);
        } else if (state is LoginFailure) {
          isLoading = false;

          showCustomSnackBar(context, state.errorMessage, color: Colors.red);
        } else if (state is ResetPassword) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                "An email for password reset has been sent to your email",
                style: TextStyle(
                    color: AppColors.offWhite, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.color6,
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            color: colors['mainColor'],
          ),
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: colors['mainColor'],
            body: Stack(children: [
              Container(
                width: width,
                height: height,
                color: colors['mainColor'],
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34,
                                  color: colors['mainColor']),
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Card(
                              elevation: 1,
                              child: TextFormField(
                                // key: formkey,
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
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Card(
                              elevation: 1,
                              child: BlocConsumer<PasswordsecureCubit,
                                      PasswordsecureState>(
                                  listener: (context, state) {
                                if (state is PasswordsecureOff) {
                                  secureColor = AppColors.color4;
                                  isSecure = false;
                                } else if (state is PasswordsecureOn) {
                                  secureColor = colors['mainColor']!;
                                  isSecure = true;
                                }
                              }, builder: (context, state) {
                                return TextFormField(
                                  obscureText: isSecure,
                                  controller: password_controller,
                                  keyboardType: TextInputType.visiblePassword,

                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
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
                                    hintText: "Password",
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                  // controller: email_controller,
                                  validator: (String? value) {
                                    if (value!.isEmpty)
                                      return "Please Enter your password";
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetpasswordScreen(
                                            color: colors['mainColor']!,
                                          ))),
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  (await BlocProvider.of<LoginCubit>(context)
                                      .loginUser(
                                          context: context,
                                          email: email_controller.text,
                                          password: password_controller.text));
                                  await BlocProvider.of<UserDataCubit>(context)
                                      .getProfilePic(
                                          BlocProvider.of<LoginCubit>(context)
                                              .getUser!
                                              .user!
                                              .uid);

                                  //      favoriteChoosed =
                                  //  BlocProvider.of<UserDataCubit>(context).userData['favoriteProducts'];
                                }
                              },
                              child: const Text(
                                "Log In",
                                style: TextStyle(fontSize: 24),
                              ),
                              style: ButtonStyle(
                                fixedSize: WidgetStateProperty.all<Size>(
                                    Size(400, 50)),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    colors['mainColor']!),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    AppColors.offWhite),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen(
                                              color: colors['mainColor']!,
                                            ))),
                                child: const Text(
                                  "Don't have an accound?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen(
                                              color: colors['mainColor']!,
                                            ))),
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.mainLightColor,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Center(child: Text("Or Log in with social account")),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await ProductServices().getProducts(
                                    path: ApiConstant.baseUrl +
                                        ApiConstant.productEndpoint,
                                  );

                                  await BlocProvider.of<LoginCubit>(context)
                                      .loginWithGoogle(context);
                                },
                                child: Container(
                                    child: Image.asset(
                                      "assests/images/googleLogo.png",
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black26,
                                            blurRadius: 0.5)
                                      ],
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppColors.bgLightColor,
                                    ),
                                    width: 92,
                                    height: 64),
                              ),
                              InkWell(
                                onTap: () async {
                                  // await signOut();
                                  final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool("onBoarding", true);
                                },
                                child: Container(
                                    child: Image.asset(
                                      "assests/images/facebookLogo.png",
                                      width: 10,
                                      height: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black26,
                                            blurRadius: 0.5)
                                      ],
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppColors.bgLightColor,
                                    ),
                                    width: 92,
                                    height: 64),
                              ),
                            ],
                          )
                        ],
                      ),
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
