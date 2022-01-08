// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, unused_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_this

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'layout/shop/cubit/cubit.dart';
import 'layout/shop/layout.dart';
import 'modules/shop_app/login/login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  if (isDark == null) {
    CacheHelper.saveData(key: 'isDark', value: false);
    isDark = false;
  }
  print("token is : $token");
  Widget widget;

  if (onBoarding != false && onBoarding != null) {
    if (token != "" && token != null)
      widget = ShopLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(News(
    isDark: isDark,
    widget: widget,
  ));
}

class News extends StatelessWidget {
  final bool isDark;
  final Widget widget;

  News({
    required this.isDark,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..switchMood(cached: this.isDark)),
        BlocProvider(
            create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: CacheHelper.getData(key: 'isDark')
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: widget,
            ),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}