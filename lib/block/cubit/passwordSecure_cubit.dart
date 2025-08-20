import 'package:cx_final_project/block/cubit_state/passwordSecure_State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordsecureCubit extends Cubit<PasswordsecureState> {
  PasswordsecureCubit() : super(PasswordsecureInitial(confirm: 0));

  void toggleState(bool value, int confirm) {
    if (value) {
      emit(PasswordsecureOff(confirm: confirm));
    } else {
      emit(PasswordsecureOn(confirm: confirm));
    }
  }
}
