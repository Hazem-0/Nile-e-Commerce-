import 'package:cx_final_project/block/cubit_state/cart_states.dart';
import 'package:cx_final_project/info/api_constants.dart';
import 'package:cx_final_project/info/cart_list.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/services/news_service.dart';
import 'package:cx_final_project/widgets/cart_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitial());

  int totalCartCount = 0;
  double totalAmount = 0;
  bool promo = true;
  void addToCart(Product product) {
    CartBox el = CartBox(product: product);
    String key = product.id.toString();
    if (cartProductCount[key] == 0) {
      cartList.add(el);
      // cartProductCount[el.product.id] =
      //     (cartProductCount[el.product.id] ?? 0) + 1;
    }
    // log(cartList.length.toString());
    // log("1 in add to cart " + cartProductCount[key].toString());
    cartProductCount[key] = cartProductCount[key] + 1;

    // print(cartProductCount[key]);
    totalCartCount += 1;
    totalAmount += (product.price);

    emit(CartItemAdded());
  }

  void removeFromCart(Product product) {
    //  CartBox el = CartBox(product: product);
    String key = product.id.toString();
    if (cartProductCount[key] == 1) {
      cartList.removeWhere((value) => value.product.id == product.id);
      // cartProductCount[id] = 0;
    }
    cartProductCount[key] = cartProductCount[key] - 1;
    totalCartCount -= 1;
    (totalCartCount == 0) ? totalAmount = 0 : totalAmount -= product.price;
    emit(CartItemRemoved());
  }

  void removeBox(Product product) {
    String key = product.id.toString();

    if (cartProductCount[key] != 0) {
      cartList.removeWhere((value) => value.product.id == product.id);

      totalCartCount -= cartProductCount[key] as int;
      (totalCartCount == 0)
          ? totalAmount = 0
          : totalAmount -= (product.price * (cartProductCount[key] ?? 1));

      cartProductCount[key] = 0;
    }
    emit(CartItemRemoved());
  }

  void restCart() {
    totalAmount = 0;
    totalCartCount = 0;
    cartList = [];
  }

  bool cartFetched = false;

  void fetchCartCount(list) async {
    // log('here cart count ' + list.toString());
    list.forEach((key, value) {
      if (value != 0) {
        totalCartCount += value as int;
      }
    });
  }

  void fetchCart(BuildContext context) async {
    late Future<List<Product>> temp = ProductServices()
        .getProducts(path: ApiConstant.baseUrl + ApiConstant.productEndpoint);
    tempAllProducts = await temp;
    try {
      Product? el;
      // log("cart fetch   0000   " + tempAllProducts.toString());
      // log(cartProductCount.toString());

      if (!cartFetched) {
        cartProductCount.forEach((key, value) {
          if (value != 0) {
            // log("i'm here yes");
            // log(tempAllProducts.toString());

            el = tempAllProducts.firstWhere(
              (test) => test!.id == int.parse(key),
            );

            if (el != null) {
              // totalCartCount += value as int;
              totalAmount += el!.price * cartProductCount[key];
              cartList.add(CartBox(product: el!));
              if (tempAllProducts.isNotEmpty) {
                // cartFetched = 0;
              }
            } else {
              // log("Product with id $key not found.");
            }
          }
        });
        cartFetched = true;

        emit(CartItemAdded());
      }
    } catch (e) {
      // log(e.toString());
    }
  }
  // void promoF(String promoCode) {
  //   if (promo) {
  //     if (promoCode == "1") {
  //       totalAmount /= 2;
  //     promo=false;
  //     }
  //   }
  //       emit(CartItemAdded());
  // }
}
