import 'dart:math';

import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/info/api_constants.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/services/news_service.dart';
import 'package:cx_final_project/widgets/banner_carousel.dart';
import 'package:cx_final_project/widgets/product_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, Color> colors;
  const HomeScreen({super.key, required this.colors});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> futureProducts;
  getProducts() async {
    return await futureProducts;
  }

  @override
  void initState() {
    super.initState();
    futureProducts = ProductServices()
        .getProducts(path: ApiConstant.baseUrl + ApiConstant.productEndpoint);
    // print(widget.colors['bgColor']);
    // BlocProvider.of<CartCubit>(context).fetchCart(context);

    BlocProvider.of<UserDataCubit>(context)
        .fetchProducts(context, getProducts());
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<UserDataCubit>(context).fetchProducts(context, futureProducts);

    Map<String, Color> colors = BlocProvider.of<ThemeCubit>(context).colors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: widget.colors['bgColor'],
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBannerCarousel(),
            FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    //   color: widget.colors['bgColor'],
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors['fontColor'],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                } else {
                  List<Product> products = snapshot.data!;
                  tempAllProducts = products;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Sale",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: colors['fontColor'],
                          ),
                        ),
                      ),
                      Container(
                        //     color: widget.colors['bgColor'],
                        height: 320,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              double randomSale = double.parse(
                                  (1 + (50 - 1) * Random().nextDouble())
                                      .toStringAsFixed(2));
                              // print(favoriteChoosed);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProductBox(
                                  colors: widget.colors,
                                  color:
                                      favoriteChoosed!["${products[index].id}"]!
                                          ? colors['mainColor']!
                                          : AppColors.color4,
                                  sale: randomSale,
                                  product: products[index],
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "All products",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: colors['fontColor'],
                          ),
                        ),
                      ),
                      Container(
                        // color: widget.colors['bgColor'],
                        // width: 230,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          // primary: true,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            Product product1 = products[index];
                            Product product2 =
                                products[(index <= 9) ? index + 10 : 0];

                            // print(favoriteChoosed);

                            // print(favoriteChoosed["1"]);
                            // // print();
                            // print(favoriteChoosed);
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ProductBox(
                                    colors: widget.colors,
                                    color: favoriteChoosed![
                                            "${products[index].id}"]!
                                        ? colors['mainColor']!
                                        : AppColors.color4,
                                    // color: AppColors.color1,
                                    sale: 0,
                                    product: product1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ProductBox(
                                    colors: widget.colors,
                                    color: favoriteChoosed![
                                                "${products[index].id}"] ??
                                            false
                                        ? colors['mainColor']!
                                        : AppColors.color4,
                                    sale: 0,
                                    // color: AppColors.color1,
                                    product: product2,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
