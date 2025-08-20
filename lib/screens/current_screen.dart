import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/pages_cubit.dart';
import 'package:cx_final_project/block/cubit/signout_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/pages_state.dart';
import 'package:cx_final_project/block/cubit_state/theme_states.dart';
import 'package:cx_final_project/info/cart_list.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/info/snackBar.dart';
import 'package:cx_final_project/screens/cart.dart';
import 'package:cx_final_project/screens/category.dart';
import 'package:cx_final_project/screens/favorite.dart';
import 'package:cx_final_project/screens/home.dart';
import 'package:cx_final_project/screens/profile.dart';
import 'package:cx_final_project/widgets/custom_BNB.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CurrentScreen extends StatelessWidget {
  Widget currentScreen;
  bool enter = true;

  Widget appbarAction = IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.search,
      size: 35,
    ),
  );

  // Map<String, dynamic>? userData;

  CurrentScreen({super.key, required this.currentScreen});
  @override
  Widget build(BuildContext context) {
    favoriteChoosed =
        context.watch<UserDataCubit>().favoriteProducts ?? favoriteChoosed;
    cartProductCount =
        context.watch<UserDataCubit>().cartProducts ?? cartProductCount;

    // BlocProvider.of<CartCubit>(context).fetchCart(context);

    Map<String, Color> colors = context.watch<ThemeCubit>().colors;
    return BlocConsumer<PagesCubit, PagesState>(listener: (context, state) {
      if (state is HomePage) {
        // favoriteChoosed = BlocProvider.of<UserDataCubit>(context)
        //     .userData!['favoriteProducts'];
        appbarAction = IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            size: 35,
          ),
        );
        currentScreen = HomeScreen(
          colors: colors,
        );
      } else if (state is FavoritePage) {
        context.read<FavoriteCubit>().updateFavorites();
        currentScreen = FavoriteScreen(
          colors: colors,
        );
      }
      if (state is CategoryPage) {
        currentScreen = CategoryScreen(
          colors: colors,
        );
      }
      if (state is CartPage) {
        // context.read<FavoriteCubit>().updateFavorites();
        BlocProvider.of<CartCubit>(context).fetchCart(context);
        currentScreen = CartScreen(
          colors: colors,
        );
      }
      if (state is ProfilePage) {
        // log('we are here ' + favoriteChoosed.toString());

        appbarAction = IconButton(
          onPressed: () async {
            await BlocProvider.of<SingoutCubit>(context).signOut(context);
            BlocProvider.of<PagesCubit>(context).changePage(8);
            // BlocProvider.of<UserDataCubit>(context).setProducts();
            favoriteChoosed!.updateAll(
              (key, value) => false,
            );
            cartProductCount.updateAll(
              (key, value) => 0,
            );
            favoriteList = [];
            BlocProvider.of<FavoriteCubit>(context).inFavList = {};
            BlocProvider.of<CartCubit>(context).restCart();
            BlocProvider.of<CartCubit>(context).cartFetched = false;
            BlocProvider.of<UserDataCubit>(context).resetBoleanCart();

            // print(BlocProvider.of<CartCubit>(context).cartFetched);
            // print(context.watch<FavoriteCubit>().inFavList);
            showCustomSnackBar(context, "Signed Out", color: Colors.green);
          },
          icon: const Icon(
            Icons.logout,
            size: 30,
          ),
          color: AppColors.offWhite,
        );
        currentScreen = ProfileScreen();
      }
    }, builder: (context, state) {
      return BlocBuilder<ThemeCubit, ThemeStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppColors.offWhite,
              actions: [
                appbarAction,
              ],
              centerTitle: true,
              title: const Text(
                "Nile",
                style: TextStyle(
                  fontFamily: "loving",
                  letterSpacing: 12,
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: colors['mainColor'],
            ),
            extendBody: true,
            backgroundColor: colors['bgColor'],
            bottomNavigationBar: CustomNavBar(
              colors: colors,
              currentIndex: 0,
              onItemTapped: (index) {},
            ),
            body: currentScreen,
            // backgroundColor: Colors.white,
          );
        },
      );
    });
  }
}
