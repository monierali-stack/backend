abstract class MainState {}

class MainInitState extends MainState {}

class MainNavChangedState extends MainState {}

class MainFavoriteToggledState extends MainState {}

class MainCartChangedState extends MainState {}

class MainHomeDataLoadingState extends MainState {}

class MainHomeDataLoadedState extends MainState {}

class MainHomeDataErrorState extends MainState {
  MainHomeDataErrorState(this.message);
  final String message;
}

class MainOrdersLoadingState extends MainState {}

class MainOrdersUpdatedState extends MainState {}

class MainOrdersErrorState extends MainState {
  MainOrdersErrorState(this.message);
  final String message;
}
