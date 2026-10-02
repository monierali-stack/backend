import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/api_error_helper.dart';
import 'package:shop/features/shop/data/models/product_model.dart';
import 'package:shop/features/shop/data/repos/shop_repo.dart';
import 'package:shop/features/shop/presentation/cubit/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitState());

  static SearchCubit get(context) => BlocProvider.of(context);

  final searchController = TextEditingController();

  List<ProductModel> results = [];
  bool isLoading = false;
  String? error;

  // Guards against an older, slower request overwriting a newer one.
  int _requestId = 0;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      results = [];
      error = null;
      emit(SearchLoadedState());
      return;
    }
    final thisRequest = ++_requestId;
    isLoading = true;
    emit(SearchLoadingState());
    try {
      final found = await ShopRepo.searchProducts(query.trim());
      if (thisRequest != _requestId) return; // a newer search superseded this one
      results = found;
      isLoading = false;
      emit(SearchLoadedState());
    } catch (e) {
      if (thisRequest != _requestId) return;
      isLoading = false;
      error = ApiErrorHelper.messageFrom(e);
      emit(SearchErrorState(error!));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
