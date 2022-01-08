import 'package:shop_app/layout/shop/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

void logout (context){
  CacheHelper.clearData(key: 'token').then((value) {
    navigatorAndFinish(context, LoginScreen(), until: false);
    ShopCubit.get(context).currentIndex = 0;
  });
}

String? token;