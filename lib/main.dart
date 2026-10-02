import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/dio_helper.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';

import 'features/splash/presentation/views/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // App-level so it's still reachable from pages pushed on top of
      // MainView (e.g. ProductDetailsView), not just its own subtree.
      create: (context) => MainCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
        ),
        home: const SplashView(),
      ),
    );
  }
}
