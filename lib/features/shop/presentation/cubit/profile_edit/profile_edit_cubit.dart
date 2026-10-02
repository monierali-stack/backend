import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/api_error_helper.dart';
import 'package:shop/features/auth/data/repos/auth_repo.dart';
import 'package:shop/features/shop/presentation/cubit/profile_edit/profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit({required String initialName, required String initialPhone})
      : fullNameController = TextEditingController(text: initialName),
        phoneController = TextEditingController(text: initialPhone),
        super(ProfileEditInitState());

  static ProfileEditCubit get(context) => BlocProvider.of(context);

  final TextEditingController fullNameController;
  final TextEditingController phoneController;

  Future<void> save() async {
    emit(ProfileEditLoadingState());
    try {
      await AuthRepo.updateProfile(
        name: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
      );
      emit(ProfileEditSavedState());
    } catch (e) {
      emit(ProfileEditErrorState(ApiErrorHelper.messageFrom(e)));
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
