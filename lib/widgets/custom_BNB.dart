import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/category_cubit.dart';
import 'package:cx_final_project/block/cubit/pages_cubit.dart';
import 'package:cx_final_project/block/cubit_state/pages_state.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// ignore: must_be_immutable
class CustomNavBar extends StatelessWidget {
  int currentIndex = 0;
  final ValueChanged<int> onItemTapped;
  final Map<String, Color> colors;

  CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PagesCubit, PagesState>(listener: (context, state) {
      if (state is HomePage) {
        currentIndex = 0;
      } else if (state is FavoritePage) {
        currentIndex = 1;
      }
      if (state is CategoryPage) {
        currentIndex = 2;
        BlocProvider.of<CategoryCubit>(context).fetchCategories();
      }
      if (state is CartPage) {
        currentIndex = 3;
      }
      if (state is ProfilePage) {
        currentIndex = 4;
      }
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: StylishBottomBar(
          borderRadius: BorderRadius.circular(100),
          elevation: 5,
          currentIndex: state.index,
          onTap: (index) {
            BlocProvider.of<PagesCubit>(context).changePage(index);
          },
          backgroundColor: colors['mainColor'],
          items: [
            BottomBarItem(
              icon: const Icon(
                Icons.home,
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // backgroundColor: AppColors.offWhite,
              selectedColor: colors['selectedColor']!,
              unSelectedColor: AppColors.offWhite,
            ),
            BottomBarItem(
              selectedColor: colors['selectedColor']!,
              unSelectedColor: AppColors.offWhite,
              icon: const Icon(Icons.favorite),
              title: const Text(
                'Favorite',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // backgroundColor: AppColors.offWhite,
            ),
            BottomBarItem(
              selectedColor: colors['selectedColor']!,
              unSelectedColor: AppColors.offWhite,
              icon: const Icon(Icons.category),
              title: const Text(
                'Category',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // backgroundColor: AppColors.offWhite,
            ),
            BottomBarItem(
              showBadge:
                  (BlocProvider.of<CartCubit>(context).totalCartCount == 0)
                      ? false
                      : true,
              badge: Text(
                context.watch<CartCubit>().totalCartCount.toString(),
                style: TextStyle(
                  color: colors['fontColor'],
                ),
              ),
              badgeColor: Colors.redAccent,
              // badgePadding: EdgeInsets.all(8),
              selectedColor: colors['selectedColor']!,
              unSelectedColor: AppColors.offWhite,
              icon: const Icon(Icons.shopping_cart),
              title: const Text(
                'Cart',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // backgroundColor: AppColors.offWhite,
            ),
            BottomBarItem(
              selectedColor: colors['selectedColor']!,
              unSelectedColor: AppColors.offWhite,
              icon: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // backgroundColor: AppColors.offWhite,
            ),
          ],
          // option: AnimatedBarOptions(
          //   iconStyle: IconStyle.animated,
          //   barAnimation: BarAnimation.liquid,
          //   iconSize: 40,
          // ),
          option: AnimatedBarOptions(
            iconSize: 50,
            iconStyle: IconStyle.animated,
            barAnimation: BarAnimation.liquid,
          ),
        ),
      );
    });
  }
}
