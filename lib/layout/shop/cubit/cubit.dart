// ignore_for_file: avoid_init_to_null, avoid_print, unused_import, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/product_item_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shop_app/modules/shop_app/products/products_screen.dart';
import 'package:shop_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Color> selectItemColor = [
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.black
  ];
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;

    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel = null;

  Map<int, bool> favorite = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data.products) {
        favorite.addAll({
          element.id: element.inFavorites,
        });
      }
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState(error));
    });
  }

  CategoriesModel? categoriesModel = null;

  void getCategories() {
    emit(ShopLoadingCategoriesState());
    DioHelper.getData(url: GET_CATEGORIES, token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState(error));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel = null;

  void changeFavorites(int productsId) {
    favorite[productsId] = !favorite[productsId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productsId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status)
        favorite[productsId] = !favorite[productsId]!;
      else
        getFavorites();
      print(value.data);
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      print(error.toString());
      favorite[productsId] = !favorite[productsId]!;
      emit(ShopErrorChangeFavoritesState(error));
    });
  }


  UserModel? userModel = null;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userModel = UserModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState(error));
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? image
  }) {
    emit(ShopLoadingUserDataState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'image': image,
    }).then((value) {
      userModel = UserModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState(error));
    });
  }

  FavoritesModel? favoritesModel = null;

  void getFavorites() {
    emit(ShopLoadingFavoritesState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorFavoritesState(error));
    });
  }

  SearchModel? searchModel = null;

  void getSearchData(String? text) {
    searchModel = null;
    emit(ShopLoadingSearchDataState());
    DioHelper.postData(url: PRODUCT_SEARCH, data: {
      'text':text,
    }).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSuccessSearchDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorSearchDataState(error));
    });
  }

  ProductItemModel? productItemModel = null;
  void getProductItemData(int id) {
    productItemModel = null;
    emit(ShopLoadingProductItemDataState());
    DioHelper.getData(url: '$PRODUCT_ITEM/$id', token: token).then((value) {
      productItemModel = ProductItemModel.fromJson(value.data);
      emit(ShopSuccessProductItemDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorProductItemDataState(error));
    });
  }

}