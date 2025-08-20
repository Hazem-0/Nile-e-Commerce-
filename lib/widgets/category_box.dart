import 'package:cx_final_project/block/cubit/category_cubit.dart';
import 'package:cx_final_project/block/cubit/theme_cubit.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBox extends StatelessWidget {
  final String category;
  final bool? selected;
  const CategoryBox(
      {super.key, required this.category, required this.selected});
  @override
  Widget build(BuildContext context) {
    Map<String, Color> colors = BlocProvider.of<ThemeCubit>(context).colors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          BlocProvider.of<CategoryCubit>(context).selecCategory(category);
          BlocProvider.of<CategoryCubit>(context)
              .selectedCategory
              .updateAll((key, value) => false);
          BlocProvider.of<CategoryCubit>(context).selectedCategory[category] =
              true;
          // log('okkkkkkkkkkkkkkkkkkk');
        },
        child: Container(
          width: category.length * 12,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ((selected ?? false))
                  ? colors['mainColor']
                  : AppColors.offWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.bgDarkColor,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                )
              ]),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                // fontFamily: "TacOne",
                // letterSpacing: 5,
                color:
                    ((selected ?? false)) ? AppColors.offWhite : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
