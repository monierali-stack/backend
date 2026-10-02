import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/components/default_text_field.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/profile_edit/profile_edit_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/profile_edit/profile_edit_state.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return BlocProvider(
      create: (context) => ProfileEditCubit(
        initialName: mainCubit.userFullName,
        initialPhone: mainCubit.userPhone,
      ),
      child: BlocConsumer<ProfileEditCubit, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditSavedState) {
            var cubit = ProfileEditCubit.get(context);
            MainCubit.get(context).updateProfile(
              fullName: cubit.fullNameController.text,
              phone: cubit.phoneController.text,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileEditErrorState) {
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
          var cubit = ProfileEditCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: AppColors.black, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.fieldFill,
                            backgroundImage: AssetImage(AppImages.avatarDefault),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Image.asset(AppImages.badgeOnline, width: 18, height: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    DefaultTextField(
                      controller: cubit.fullNameController,
                      hint: 'Full Name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      controller: cubit.phoneController,
                      hint: 'Phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    DefaultBtn(
                      text: 'Save',
                      onTap: cubit.save,
                      loading: state is ProfileEditLoadingState,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
