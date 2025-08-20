import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  String? userToken;
  Map<String, bool> gotBefore = {};
  UserCredential? getUser;
  Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    emit(LoginLoading());

    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userToken = user.user!.uid;
      getUser = user;
      gotBefore[userToken!] = true;
      await pref.setString("login", userToken!);

      emit(LoginSuccess());
      // await BlocProvider.of<UserDataCubit>(context).getProfilePic(userToken!);
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        emit(LoginFailure(errorMessage: "User-not-found"));
      } else if (e.code == "wrong-password") {
        emit(LoginFailure(errorMessage: "Wrong-Password"));
      }
      emit(LoginFailure(errorMessage: e.code));
    } catch (e) {
      emit(LoginFailure(errorMessage: "Something went wrong!"));
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    emit(LoginLoading());

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(LoginFailure(errorMessage: "Google sign-in canceled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      getUser = user;

      userToken = user.user!.uid;
      // log(userToken!);
      // log(gotBefore.toString());
      // log("gotbefore " + gotBefore[userToken!].toString());

      final DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userToken)
          .get();

      if (!userDocSnapshot.exists) {
        // If the user's document doesn't exist, set the user data
        BlocProvider.of<UserDataCubit>(context).setUserData(
          getUser!,
          user.user!.displayName ?? "not-found",
          user.user!.phoneNumber ?? "not-found",
          user.user!.email ?? "not-found",
        );
      }
      gotBefore[userToken!] = true;
      await pref.setString("login", userToken!);
      //  await  BlocProvider.of<UserDataCubit>(context).getProfilePic(userToken!);
      emit(LoginSuccess());

      // emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(errorMessage: "Failed to sign in with Google: $e"));
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPassword());
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }
}
