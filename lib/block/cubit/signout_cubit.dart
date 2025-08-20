import 'dart:developer';

import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/signout_state.dart';
import 'package:cx_final_project/screens/logIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingoutCubit extends Cubit<SignoutState> {
  SingoutCubit() : super(SignoutInitial());
  Future<void> signOut(BuildContext ctx) async {
    emit(SignoutLoading());
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      print('signed out ');

      //  await BlocProvider.of<UserDataCubit>(ctx)
      //       .updateUserData(favoriteChoosed, "favoriteProducts");
      //  await BlocProvider.of<UserDataCubit>(ctx)
      //       .updateUserData(cartProductCount, "cartProducts");
      // favoriteChoosed.updateAll((key, value) => false);
      // cartProductCount.updateAll((key, value) => 0);
      // BlocProvider.of<CartCubit>(ctx).totalAmount = 0;
      // BlocProvider.of<CartCubit>(ctx).totalCartCount = 0;
      // cartList = [];
      // favoriteList = [];

      BlocProvider.of<UserDataCubit>(ctx).userImage = null;
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (ctx) => LoginScreen()));
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("login", "false");
      emit(SingoutSuccuss());
    } on FirebaseException catch (e) {
      log(e.code);
      emit(SingoutFailure());
    }
  }
}
