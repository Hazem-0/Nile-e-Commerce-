import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/favorite_states.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/widgets/wide_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitial());

  void addFavorite(Product product, BuildContext context) {
    WideBox el = WideBox(product: product);
    if (!favoriteChoosed![el.product.id.toString()]!) {
      //  favoriteList.add(el);
      favoriteChoosed![el.product.id.toString()] = true;
      BlocProvider.of<UserDataCubit>(context).setProducts();
      updateFavorites();
      emit(FavoriteChoosed());
    }
  }

  void removeFavorite(String id, BuildContext context) {
    favoriteList.removeWhere((value) => value.product.id == id);
    favoriteChoosed![id] = false;
    // BlocProvider.of<UserDataCubit>(context)
    //       .updateUserData(favoriteChoosed, "favoriteProducts");

    BlocProvider.of<UserDataCubit>(context).setProducts();
    updateFavorites();

    emit(FavoriteUnChoosed());
  }

  Map<int, bool>? inFavList = {};
  void updateFavorites() {
    // log(favoriteChoosed.toString());
    favoriteChoosed!.forEach((key, value) {
      {
        Product product =
            tempAllProducts.firstWhere((el) => el!.id == int.parse(key))!;
        if (value == true) {
          if (inFavList!.containsKey(product.id)) {
            if (inFavList![product.id] == false) {
              favoriteList.add(WideBox(product: product));
              inFavList![product.id] = true;
            }
          } else {
            favoriteList.add(WideBox(product: product));
            inFavList![product.id] = true;
          }
        } else {
          if (inFavList!.containsKey(product.id)) {
            if (inFavList![product.id] == true) {
              favoriteList
                  .removeWhere((value) => value.product.id == product.id);
              inFavList![product.id] = false;
            }
          }
        }
      }
    });
  }
}
