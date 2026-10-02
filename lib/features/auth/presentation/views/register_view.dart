import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/components/default_text_field.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:shop/features/auth/presentation/cubit/register/register_state.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/views/main_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            var cubit = RegisterCubit.get(context);
            MainCubit.get(context).updateProfile(
              fullName: cubit.registeredUser?.name.isNotEmpty == true
                  ? cubit.registeredUser!.name
                  : cubit.fullNameController.text,
              phone: cubit.phoneController.text,
            );
            if (cubit.registeredUser != null) {
              MainCubit.get(context)
                  .seedFavorites(cubit.registeredUser!.favoriteProductIds);
            }
            goTo(context, toPage: const MainView(), type: NavigatorType.replace);
          } else if (state is RegisterErrorState) {
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
          var cubit = RegisterCubit.get(context);
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
                        'Create an account',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      DefaultTextField(
                        controller: cubit.fullNameController,
                        hint: 'Full Name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Please enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DefaultTextField(
                        controller: cubit.phoneController,
                        hint: 'Phone',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Please enter your phone number'
                            : null,
                      ),
                      const SizedBox(height: 16),
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
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DefaultTextField(
                        controller: cubit.confirmPasswordController,
                        hint: 'Confirm Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: cubit.obscureConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: cubit.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            cubit.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.darkGery,
                          ),
                        ),
                        validator: (value) {
                          if (value != cubit.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: AppColors.darkGery, fontSize: 12, height: 1.5),
                          children: [
                            const TextSpan(text: 'By clicking the '),
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: ' button, you agree to the public offer',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      DefaultBtn(
                        text: 'Create Account',
                        onTap: cubit.register,
                        loading: state is RegisterLoadingState,
                      ),
                      const SizedBox(height: 24),
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
