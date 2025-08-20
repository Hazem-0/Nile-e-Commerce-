import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/favorite_states.dart';
import 'package:cx_final_project/block/cubit_state/user_data_states.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/screens/details.dart';
import 'package:cx_final_project/widgets/rating.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBox extends StatelessWidget {
  final Product product;
  final double sale;
  final Color color;
  final Map<String, Color> colors;
  ProductBox({
    super.key,
    required this.product,
    required this.sale,
    required this.color,
    required this.colors,
  });
  @override
  //  Map<int,Color> ?heartColor ={1:AppColors.color4}  ;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            product: product,
          ),
        ),
      ),
      child: BlocBuilder<UserDataCubit, UserDataStates>(
        builder: (context, state) {
          return Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
              //  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (sale == 0)
                          ? const SizedBox(
                              width: 100,
                            )
                          : Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0X77CFCFCF),
                              ),
                              child: Center(
                                child: Text(
                                  "${sale}%OFF",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      BlocBuilder<FavoriteCubit, FavoriteStates>(
                        builder: (context, state) {
                          return Container(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () =>
                                  (!favoriteChoosed!["${product.id}"]!)
                                      ? BlocProvider.of<FavoriteCubit>(context)
                                          .addFavorite(product, context)
                                      : BlocProvider.of<FavoriteCubit>(context)
                                          .removeFavorite(
                                              "${product.id}", context),
                              icon: Icon(
                                Icons.favorite,
                                color:
                                    favoriteChoosed!["${product.id}"] ?? false
                                        ? AppColors.mainLightColor
                                        : AppColors.color4,
                              ),
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.bgDarkColor,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ],
                              shape: BoxShape.circle,
                              color: AppColors.bgLightColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        // fit: BoxFit.fitHeight,
                        image: NetworkImage(product.image),
                        alignment: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: Text(
                      maxLines: 2,
                      product.title,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          (sale > 0)
                              ? Text(
                                  "${(product.price - (product.price * (sale / 100))).toStringAsFixed(2)} \$",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          Text(
                            "${product.price} \$",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (sale > 0) ? Colors.grey : Colors.black,
                              decoration: (sale > 0)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Ratingx(rating: product.rating.rate, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
