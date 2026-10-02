import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/components/default_text_field.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:shop/features/auth/presentation/cubit/login/login_state.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/views/main_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            var cubit = LoginCubit.get(context);
            if (cubit.loggedInUser != null && cubit.loggedInUser!.name.isNotEmpty) {
              MainCubit.get(context).updateProfile(
                fullName: cubit.loggedInUser!.name,
                phone: cubit.loggedInUser!.phone,
              );
              MainCubit.get(context).seedFavorites(cubit.loggedInUser!.favoriteProductIds);
            }
            goTo(context, toPage: const MainView(), type: NavigatorType.replace);
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: cubit.formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      DefaultTextField(
                        controller: cubit.emailController,
                        hint: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DefaultTextField(
                        controller: cubit.passwordController,
                        hint: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: cubit.obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: cubit.togglePasswordVisibility,
                          icon: Icon(
                            cubit.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.darkGery,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      DefaultBtn(
                        text: 'Login',
                        onTap: cubit.login,
                        loading: state is LoginLoadingState,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
