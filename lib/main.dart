import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/category_cubit.dart';
import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/login_cubit.dart';
import 'package:cx_final_project/block/cubit/pages_cubit.dart';
import 'package:cx_final_project/block/cubit/passwordSecure_cubit.dart';
import 'package:cx_final_project/block/cubit/register_cubit.dart';
import 'package:cx_final_project/block/cubit/signout_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCIEBJcc5fO02X9Qoe455mVPYCABgXWyeo",
        appId: "1:512547465684:android:fb567a3757632303458e41",
        messagingSenderId: "512547465684",
        projectId: "e-commerce-6f7b5"),
  );

  FirebaseAuth.instance.setLanguageCode('en');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => PasswordsecureCubit()),
        BlocProvider(create: (context) => PagesCubit()),
        BlocProvider(create: (context) => SingoutCubit()),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => FavoriteCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => UserDataCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        //CurrentScreen(currentScreen: HomeScreen(),),
      ),
    );
  }
}
