import 'package:cx_final_project/block/cubit/favorite_cubit.dart';
import 'package:cx_final_project/block/cubit_state/favorite_states.dart';
import 'package:cx_final_project/info/favorite_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  final Map<String, Color> colors;
  const FavoriteScreen({super.key, required this.colors});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteStates>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: colors['bgColor'],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        "Favorite items:",
                        style: TextStyle(
                          color: colors['fontColor'],
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Spacer(),
                      TweenAnimationBuilder(
                        duration: const Duration(seconds: 1),
                        tween: IntTween(begin: 0, end: favoriteList.length),
                        builder: (context, value, child) => Text(
                          " ${value}",
                          style: TextStyle(
                              color: colors['fontColor'],
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TacOne"),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 80),
                  itemCount: favoriteList.length,
                  itemBuilder: (context, index) {
                    return favoriteList[index];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
