// ignore_for_file: unused_import, prefer_typing_uninitialized_variables

import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/models/user_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

// home screen.
class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {
  final error;

  ShopErrorHomeDataState(this.error);
}

// categories.
class ShopLoadingCategoriesState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {
  final error;

  ShopErrorCategoriesState(this.error);
}

// real time fave changing .
class ShopChangeFavoritesState extends ShopStates {}

// post fave.
class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {
  final error;

  ShopErrorChangeFavoritesState(this.error);
}

// get fave.
class ShopLoadingFavoritesState extends ShopStates {}

class ShopSuccessFavoritesState extends ShopStates {}

class ShopErrorFavoritesState extends ShopStates {
  final error;

  ShopErrorFavoritesState(this.error);
}

// get user data
class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final UserModel? model;

  ShopSuccessUserDataState(this.model);
}

class ShopErrorUserDataState extends ShopStates {
  final error;

  ShopErrorUserDataState(this.error);
}

// get search data
class ShopLoadingSearchDataState extends ShopStates {}

class ShopSuccessSearchDataState extends ShopStates {}

class ShopErrorSearchDataState extends ShopStates {
  final error;

  ShopErrorSearchDataState(this.error);
}

// get product item data
class ShopLoadingProductItemDataState extends ShopStates {}

class ShopSuccessProductItemDataState extends ShopStates {}

class ShopErrorProductItemDataState extends ShopStates {
  final error;

  ShopErrorProductItemDataState(this.error);
}
