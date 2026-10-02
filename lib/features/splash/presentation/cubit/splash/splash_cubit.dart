import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/splash/presentation/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitState());

  static SplashCubit get(context) => BlocProvider.of(context);

  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashNavigateState());
  }
}
