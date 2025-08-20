import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/screens/details.dart';
import 'package:cx_final_project/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WideBox extends StatelessWidget {
  final Product product;
  WideBox({
    super.key,
    required this.product,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(product: product))),
      child: Stack(
        children: [
          Container(
            width: 400,
            height: 190,
          ),
          Positioned(
            child: Container(
              width: 400,
              height: 170,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 7),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: AppColors.bgLightColor,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // fit: BoxFit.fitHeight,
                          image: NetworkImage(product.image),
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            product.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Ratingx(
                              rating: product.rating.rate,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${product.rating.count}",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Text(
                          "${product.price} \$",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 350,
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () => BlocProvider.of<FavoriteCubit>(context)
                    .removeFavorite("${product.id}", context),
                icon: Icon(
                  size: 25,
                  Icons.favorite,
                  color: AppColors.mainLightColor,
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bgDarkColor,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
                shape: BoxShape.circle,
                color: AppColors.bgLightColor,
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 300,
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<CartCubit>(context).addToCart(product);
                  BlocProvider.of<UserDataCubit>(context).setProducts();
                  BlocProvider.of<CartCubit>(context).cartFetched = true;
                },
                icon: Icon(
                  size: 25,
                  Icons.add_shopping_cart_outlined,
                  color: AppColors.mainDarkColor,
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bgDarkColor,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
                shape: BoxShape.circle,
                color: AppColors.bgLightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
