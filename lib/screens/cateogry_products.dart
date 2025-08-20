import 'dart:math';
import 'package:cx_final_project/block/cubit/category_cubit.dart';
import 'package:cx_final_project/block/cubit_state/category_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/widgets/product_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CateogryProducts extends StatelessWidget {
  CateogryProducts({super.key});

  late String category;

  late List<Product> products;
  bool isLoading = false;
  bool isFound = false;

  void assgin(value) async {
    products = await value;
  }

  // int counter = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryStates>(
        listener: (context, state) async {
      if (state is CategoryLoading) {
        isLoading = true;
      }
      if (state is CategorySelected) {
        // assgin(state.futureProducts);
        products = state.futureProducts;
        category = state.selectedCtegory;
        // print(products.length);
        isFound = true;
        isLoading = false;
        // print(isLoading);
      }
      if (state is CategoryNotFound) {
        // print("44444444444444444");
        isFound = false;
        isLoading = false;
      }
    }, builder: (context, state) {
      return FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            // print(isLoading);
            if (isLoading) {
              return Container(
                width: double.infinity,
                height: 600,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainLightColor,
                  ),
                ),
              );
            } else if (!isFound) {
              return Container(
                height: 600,
                child: const Center(
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  // print("i'm here ");
                  Product product1 = products[index];
                  double randomSale = double.parse(
                      (1 + (70 - 1) * Random().nextDouble())
                          .toStringAsFixed(2));

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ProductBox(
                      colors: {},
                      color: favoriteChoosed![products[index].id]!
                          ? AppColors.mainLightColor
                          : AppColors.color4,
                      // color: AppColors.color1,
                      sale: (index % 2 == 0) ? 0 : randomSale,
                      product: product1,
                    ),
                  );
                },
              );
            }
          });
    });
  }
}
