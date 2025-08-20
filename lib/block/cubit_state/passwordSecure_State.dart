abstract class PasswordsecureState {
  int confirm;
  PasswordsecureState({required this.confirm});
}

class PasswordsecureInitial extends PasswordsecureState {
  PasswordsecureInitial({required super.confirm});
}

class PasswordsecureOn extends PasswordsecureState {
  PasswordsecureOn({required super.confirm});
}

class PasswordsecureOff extends PasswordsecureState {
  PasswordsecureOff({required super.confirm});
}
