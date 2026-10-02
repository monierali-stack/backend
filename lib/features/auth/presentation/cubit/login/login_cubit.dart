import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/api_error_helper.dart';
import 'package:shop/features/auth/data/models/user_model.dart';
import 'package:shop/features/auth/data/repos/auth_repo.dart';
import 'package:shop/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  UserModel? loggedInUser;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginObscureChangedState());
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    emit(LoginLoadingState());
    try {
      loggedInUser = await AuthRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(ApiErrorHelper.messageFrom(e)));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
