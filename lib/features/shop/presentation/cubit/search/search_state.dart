abstract class SearchState {}

class SearchInitState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {}

class SearchErrorState extends SearchState {
  SearchErrorState(this.message);
  final String message;
}
