import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/screens/current_screen.dart';
import 'package:cx_final_project/screens/home.dart';
import 'package:cx_final_project/screens/logIn_screen.dart';
import 'package:cx_final_project/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color color3 = const Color(0xFFB71A1A);

  Color color2 = AppColors.mainLightColor;

  Color color1 = AppColors.color4;
  Map<String, Color>? colors;
  @override
  Widget build(BuildContext context) {
    colors = BlocProvider.of<ThemeCubit>(context).colors;

    color2 = BlocProvider.of<ThemeCubit>(context).colors['mainColor']!;
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          focal: Alignment.center,
          focalRadius: 0.2,
          radius: 1.1005,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 260,
            ),
            Image.asset(
              "assests/images/splash_screen_img.png",
              height: 270,
            ),
            const Text(
              "Nile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 90,
                fontFamily: "Loving",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              value: null, // Indeterminate (loading) state
              strokeWidth: 2.0, // Thickness of the circle
              backgroundColor: color2, // Background color
              valueColor:
                  AlwaysStoppedAnimation<Color>(color1), // Color of the circle
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  bool? onBoarding;
  String? loggedin;
  void setDarkMode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (await pref.getBool("isDark") == null)
      await pref.setBool("isDark", false);
  }

  Future<void> checkOnBoard() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    onBoarding = await pref.getBool("onBoarding") ?? true;
  }

  Future<void> checkLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    loggedin = await pref.getString("login") ?? "false";
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    setDarkMode();
    checkOnBoard();
    checkLogin();
    BlocProvider.of<ThemeCubit>(context).getTheme();

    BlocProvider.of<LoginCubit>(context).userToken = loggedin;
    BlocProvider.of<UserDataCubit>(context).fetchUserData();
    // BlocProvider.of<UserDataCubit>(context).fetchProducts();

    //   Map<String, bool> fetchedFavorite =
    //       BlocProvider.of<UserDataCubit>(context).userData['favoriteProducts'];
    //   if (fetchedFavorite != null) {
    //     log('yes im here ');
    //     favoriteChoosed = fetchedFavorite;
    //  print(favoriteChoosed);
    //   }
    //   Map<String, int> fetchedCartProducts =
    //       BlocProvider.of<UserDataCubit>(context).userData['cartProducts'];
    //   if (fetchedCartProducts != null) {
    //     cartProductCount = fetchedCartProducts;
    //   }
    // cartProductCount =
    //     BlocProvider.of<UserDataCubit>(context).userData['cartProducts'];

    // favoriteChoosed =
    //     BlocProvider.of<UserDataCubit>(context).userData['favoriteProducts'];
    // print("11111111000000"+favoriteChoosed.toString());
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return (onBoarding ?? true)
              ? OnboardingScreen()
              : (loggedin != "false" ?? false)
                  ? CurrentScreen(
                      currentScreen: HomeScreen(
                      colors: colors!,
                    ))
                  : LoginScreen();
          //: CurrentScreen(currentScreen: HomeScreen(colors:colors!,));
        }),
      );
    });
  }
}
