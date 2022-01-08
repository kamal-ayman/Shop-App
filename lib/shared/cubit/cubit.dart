import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isDark = true;

  void switchMood({cached}) {
    if (cached != null) {
      isDark = cached;
      emit(SwitchMoodState());
      return;
    }
    isDark = !isDark;
    CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
      emit(SwitchMoodState());
    });
  }
}
