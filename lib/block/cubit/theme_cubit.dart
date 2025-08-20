import 'dart:ui';

import 'package:cx_final_project/block/cubit_state/theme_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitial());
  bool? isDark;

  Map<String, Color> colors = {
    'mainColor': AppColors.mainLightColor,
    'bgColor': AppColors.bgLightColor,
    'fontColor': AppColors.bgDarkColor,
    'selectedColor': AppColors.mainDarkColor,
  };

  void toggleTheme(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isDark", value);
    // print(value);
    if (value == true) {
      isDark = value;
      colors = {
        'mainColor': AppColors.mainDarkColor,
        'bgColor': AppColors.bgDarkColor,
        'fontColor': AppColors.bgLightColor,
        'selectedColor': AppColors.mainLightColor,
      };
      emit(DarkTheme());
    } else {
      isDark = value;

      colors = {
        'mainColor': AppColors.mainLightColor,
        'bgColor': AppColors.bgLightColor,
        'fontColor': AppColors.bgDarkColor,
        'selectedColor': AppColors.mainDarkColor,
      };
      emit(LightTehme());
    }
  }

  Future<void> getTheme() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    isDark = await pref.getBool("isDark");
    if (isDark ?? false) {
      colors = {
        'mainColor': AppColors.mainDarkColor,
        'bgColor': AppColors.bgDarkColor,
        'fontColor': AppColors.bgLightColor,
        'selectedColor': AppColors.mainLightColor,
      };
      emit(DarkTheme());
    } else {
      colors = {
        'mainColor': AppColors.mainLightColor,
        'bgColor': AppColors.bgLightColor,
        'fontColor': AppColors.bgDarkColor,
        'selectedColor': AppColors.mainDarkColor,
      };
      emit(LightTehme());
    }
  }
}
