import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/api_error_helper.dart';
import 'package:shop/features/auth/data/models/user_model.dart';
import 'package:shop/features/auth/data/repos/auth_repo.dart';
import 'package:shop/features/auth/presentation/cubit/register/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  UserModel? registeredUser;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(RegisterObscureChangedState());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(RegisterObscureChangedState());
  }

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    emit(RegisterLoadingState());
    try {
      registeredUser = await AuthRepo.register(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      );
      emit(RegisterSuccessState());
    } catch (e) {
      emit(RegisterErrorState(ApiErrorHelper.messageFrom(e)));
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
