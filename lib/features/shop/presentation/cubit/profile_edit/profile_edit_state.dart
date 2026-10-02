abstract class ProfileEditState {}

class ProfileEditInitState extends ProfileEditState {}

class ProfileEditLoadingState extends ProfileEditState {}

class ProfileEditSavedState extends ProfileEditState {}

class ProfileEditErrorState extends ProfileEditState {
  ProfileEditErrorState(this.message);
  final String message;
}
