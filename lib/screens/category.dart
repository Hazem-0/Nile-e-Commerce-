import 'dart:math';

import 'package:cx_final_project/block/cubit/category_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit_state/category_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/widgets/category_box.dart';
import 'package:cx_final_project/widgets/product_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, required this.colors});
  final Map<String, Color> colors;
  late List? categories;
  bool isLoading = true;
  bool isFound = false;
  bool appear = false;

  late List<Product> products;
  bool isProductsLoading = true;
  bool isProductsFound = false;
  String? category;

  @override
  Widget build(BuildContext context) {
    Map<String, Color> colors = BlocProvider.of<ThemeCubit>(context).colors;

    return BlocConsumer<CategoryCubit, CategoryStates>(
      listener: (context, state) {
        if (state is ProductsLoading) {
          isProductsLoading = true;
        }
        if (state is CategorySelected) {
          // print('yes i got here');
          // assgin(state.futureProducts);
          products = state.futureProducts;
          category = state.selectedCtegory;
          // print(products.length);
          isProductsFound = true;
          isProductsLoading = false;
          // print(isProductsLoading);
        }
        if (state is CategoryNotFound) {
          isProductsFound = false;
          isProductsLoading = false;
        }

        if (state is CategoriesFetched) {
          categories = state.category;
          isFound = true;
          isLoading = false;
        } else if (state is CategoryNotFound) {
          isFound = false;
          isLoading = false;
        }
        if (state is CategorySelected) {
          appear = true;
          // isProductsLoading = true;
          // isProductsFound = false;
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: colors['bgColor'],
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  // color:colors['bgColor'],
                  height: 60,
                  child: FutureBuilder(
                      future: null,
                      builder: (context, snapshot) {
                        if (isLoading) {
                          return SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: colors['fontColor'],
                              ),
                            ),
                          );
                        } else if (!isFound) {
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // padding: EdgeInsets.symmetric(vertical: 30),
                            itemCount: categories!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryBox(
                                  category: categories![index],
                                  selected: context
                                      .watch<CategoryCubit>()
                                      .selectedCategory[categories![index]]);
                            },
                          );
                        }
                      }),
                ),
                (appear)
                    ? FutureBuilder(
                        future: null,
                        builder: (context, snapshot) {
                          // print(isProductsLoading);
                          // print(products);

                          if (isProductsLoading) {
                            return SizedBox(
                              width: double.infinity,
                              height: 600,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colors['fontColor'],
                                ),
                              ),
                            );
                          } else if (!isProductsFound) {
                            return const SizedBox(
                              height: 600,
                              child: Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 60,
                                ),
                              ),
                            );
                          } else {
                            return GridView.builder(
                              // crossAxisCount: 2,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 100),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 0.6),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                // print("i'm here ");
                                int idx = index;
                                // print(idx);
                                if (index == products.length) {
                                  // print('yeeeees ');
                                  return Container();
                                }

                                Product product1 = products[idx];
                                double randomSale = double.parse(
                                    (1 + (70 - 1) * Random().nextDouble())
                                        .toStringAsFixed(2));

                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ProductBox(
                                    colors: const {},
                                    color: favoriteChoosed![
                                                products[idx].id.toString()] ??
                                            false
                                        ? AppColors.mainLightColor
                                        : AppColors.color4,
                                    // color: AppColors.color1,
                                    sale: (idx % 2 == 0) ? 0 : randomSale,
                                    product: product1,
                                  ),
                                );
                              },
                            );
                          }
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
