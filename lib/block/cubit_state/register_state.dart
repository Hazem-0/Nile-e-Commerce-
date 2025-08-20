abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class Registersuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  String errorMessage;
  RegisterFailure({required this.errorMessage});
}

class RegisterLoading extends RegisterState {}
