// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app/modules/shop_app/register/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  bool obscureText = true;
  IconData suffix = Icons.visibility_outlined;

  void obscureTextFun() {
    obscureText = !obscureText;
    suffix =
        obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegisterObscureTextState());
  }

  late LoginModel loginModel;

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: REGISTER, data: {
      'email': email,
      'password': password,
      'name' : name,
      'phone' : phone,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((err) {
      print(err);
      emit(ShopRegisterErrorState(err.toString()));
    });
  }
}
