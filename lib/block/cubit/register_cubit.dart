import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await BlocProvider.of<UserDataCubit>(context)
          .setUserData(user, name, phone, email);

      emit(Registersuccess());
    } on FirebaseException catch (e) {
      emit(RegisterFailure(errorMessage: e.code));
    } catch (e) {
      emit(RegisterFailure(errorMessage: "Something went wrong!"));
    }
  }
}
