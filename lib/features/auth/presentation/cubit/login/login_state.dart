abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginObscureChangedState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  LoginErrorState(this.message);
  final String message;
}
