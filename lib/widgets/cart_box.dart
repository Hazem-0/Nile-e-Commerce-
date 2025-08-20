import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit/user_data_cubit.dart';
import 'package:cx_final_project/block/cubit_state/cart_states.dart';
import 'package:cx_final_project/info/cart_list.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBox extends StatelessWidget {
  final Product product;
  const CartBox({super.key, required this.product});

  final String item1 = 'first item', item2 = 'second item';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                blurStyle: BlurStyle.solid,
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3)),
          ],
        ),
        child: Stack(
          children: [
            Container(
              width: 400,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.bgLightColor,
              ),
              child: BlocBuilder<CartCubit, CartStates>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
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
                            const SizedBox(
                              height: 10,
                            ),
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
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartCubit>(context)
                                          .removeFromCart(product);
                                      BlocProvider.of<UserDataCubit>(context)
                                          .setProducts();
                                    },
                                    icon: Icon(
                                      size: 25,
                                      Icons.remove,
                                      color: Colors.black,
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
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    cartProductCount[product.id.toString()]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartCubit>(context)
                                          .addToCart(product);
                                      BlocProvider.of<UserDataCubit>(context)
                                          .setProducts();
                                    },
                                    icon: Icon(
                                      size: 25,
                                      Icons.add,
                                      color: Colors.black,
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
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    width: 80,
                                    height: 60,
                                    child: TweenAnimationBuilder(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      tween: Tween<double>(
                                        begin: 0,
                                        end: (product.price *
                                            (cartProductCount[
                                                    product.id.toString()] ??
                                                1)),
                                      ),
                                      builder: (context, value, child) => Text(
                                        value.toStringAsFixed(2) + " \$",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              left: 360,
              child: PopupMenuButton(
                elevation: 10,
                iconColor: AppColors.mainDarkColor,
                color: AppColors.color4,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      "Add to favorite",
                    ),
                    value: item1,
                  ),
                  PopupMenuItem(
                    child: const Text(
                      "Delete from the cart",
                    ),
                    value: item2,
                  ),
                ],
                onSelected: (String newvalue) => {
                  if (newvalue == item2)
                    {BlocProvider.of<CartCubit>(context).removeBox(product)}
                  else if (newvalue == item1)
                    {
                      BlocProvider.of<FavoriteCubit>(context)
                          .addFavorite(product, context)
                    }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
