import 'dart:async';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:flutter/material.dart';

class CustomBannerCarousel extends StatefulWidget {
  @override
  State<CustomBannerCarousel> createState() => _CustomBannerCarouselState();
}

class _CustomBannerCarouselState extends State<CustomBannerCarousel> {
  List<BannerModel> listBanners = [
    BannerModel(imagePath: 'assests/images/banner1.png', id: "1"),
    BannerModel(imagePath: "assests/images/banner2.png", id: "2"),
    BannerModel(imagePath: "assests/images/banner3.png", id: "3"),
    BannerModel(imagePath: "assests/images/banner4.png", id: "4"),
  ];

  final PageController pageController = PageController();

  Timer? timer;

  int index = 0;

  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (index < listBanners.length - 1) {
        index++;
      } else {
        index = 0;
      }
      pageController.animateToPage(
        index,
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BannerCarousel.fullScreen(
      pageController: pageController,
      height: 230,
      banners: listBanners,
      customizedIndicators: const IndicatorModel.animation(
          width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
      activeColor: AppColors.mainLightColor,
      disableColor: AppColors.color3,
    );
  }
}
