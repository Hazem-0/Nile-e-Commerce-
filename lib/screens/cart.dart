import 'package:cx_final_project/block/cubit/cart_cubit.dart';
import 'package:cx_final_project/block/cubit_state/cart_states.dart';
import 'package:cx_final_project/info/cart_list.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CartScreen extends StatelessWidget {
  final Map<String, Color> colors;
  CartScreen({super.key, required this.colors});

  TextEditingController promoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colors['bgColor'],
      child: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Total amount:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: (colors['mainColor'] ==
                                      AppColors.mainLightColor)
                                  ? Colors.grey
                                  : colors['fontColor']),
                        ),
                        const Spacer(),
                        BlocBuilder<CartCubit, CartStates>(
                          builder: (context, state) {
                            return TweenAnimationBuilder(
                                duration: const Duration(seconds: 1),
                                tween: Tween<double>(
                                    begin: 0,
                                    end:
                                        context.watch<CartCubit>().totalAmount),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: colors['fontColor'],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 3,
                    color: AppColors.bgLightColor,
                    child: TextField(
                      controller: promoController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        hintText: "Enter your promo code",
                        fillColor: AppColors.offWhite,
                        suffixIcon: IconButton.filledTonal(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              colors['mainColor']!,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            // BlocProvider.of<CartCubit>(context)
                            //     .promoF(promoController.text);
                          },
                          icon: const Icon(
                            size: 30,
                            Icons.arrow_forward_rounded,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    // itemExtent: 0.5,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartList.length,
                    itemBuilder: (context, index) => cartList[index],
                  ),
                  // Spacer(),
                  SizedBox(
                    height: (cartList.length == 1) ? 210 : 20,
                  ),
                  (cartList.isNotEmpty)
                      ? SizedBox(
                          width: 200,
                          height: 50,
                          // color: Colors.red,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xff00A8E6),
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.bgLightColor),
                            ),
                            onPressed: () => null,
                            child: const Text(
                              "Check out ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
