import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: 20.0 * message.length,
      behavior: SnackBarBehavior.floating,
      content: Container(
          height: 50,
          decoration: BoxDecoration(
            color: color ?? AppColors.mainLightColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
              child: Text(
            message,
            style: TextStyle(
              color: AppColors.bgLightColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ))),
    ),
  );
}
