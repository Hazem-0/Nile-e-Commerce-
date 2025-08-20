import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/favorite_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  final Product product;
  Map<String, Color>? colors;
  DetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    colors = BlocProvider.of<ThemeCubit>(context).colors;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Nile",
          style: TextStyle(
            fontFamily: "loving",
            letterSpacing: 12,
            color: AppColors.offWhite,
            fontSize: 62,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: AppColors.offWhite,
        backgroundColor: colors!['mainColor'],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: (colors!['bgColor'] == AppColors.bgLightColor)
              ? colors!['bgColor']
              : Colors.black87,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 270,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: AppColors.bgLightColor,
                  image: DecorationImage(
                    image: NetworkImage(
                      product.image,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WD 2TB Elements Portable External Hard Drive - USB 3.0",
                      style: TextStyle(
                        color: colors!['fontColor'],
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Ratingx(
                          rating: product.rating.rate,
                          size: 35,
                        ),
                        BlocBuilder<FavoriteCubit, FavoriteStates>(
                          builder: (context, state) {
                            return Container(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                onPressed: () => (!favoriteChoosed![
                                        product.id.toString()]!)
                                    ? BlocProvider.of<FavoriteCubit>(context)
                                        .addFavorite(product, context)
                                    : BlocProvider.of<FavoriteCubit>(context)
                                        .removeFavorite(
                                            "${product.id}", context),
                                icon: Center(
                                  child: Icon(
                                    size: 28,
                                    Icons.favorite,
                                    color: favoriteChoosed!["${product.id}"]!
                                        ? colors!['mainColor']
                                        : AppColors.color4,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors!['mainColor']!,
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  color: AppColors.color6),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${product.price} \$",
                          style: TextStyle(
                            color: colors!['fontColor'],
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "Available in stock",
                          style: TextStyle(
                            color: colors!['fontColor'],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "About",
                      style: TextStyle(
                        color: colors!['fontColor'],
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: colors!['fontColor'],
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: colors!['mainColor'],
        foregroundColor: AppColors.color4,
        onPressed: () {
          BlocProvider.of<CartCubit>(context).addToCart(product);
          BlocProvider.of<UserDataCubit>(context).setProducts();
          BlocProvider.of<CartCubit>(context).cartFetched = true;
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
