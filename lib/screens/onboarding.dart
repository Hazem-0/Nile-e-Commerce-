import 'package:cx_final_project/info/colors/color_provider.dart';
import 'package:cx_final_project/screens/logIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List boarding = const [
    {
      "imgPath": "assests/images/onBoarding1.gif",
      "title": "Looking for your needs"
    },
    {
      "imgPath": "assests/images/onBoarding2.gif",
      "title": "The quickest delivery you'll ever experience!"
    },
    {
      "imgPath": "assests/images/onBoarding3.png",
      "title": "Get cash back and save more on every purchase!"
    }
  ];
  bool isLastPage = false;

  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Widget buildBoardingItem(Map<String, String> item) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image(image: AssetImage(item['imgPath']!)),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                item['title']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bgLightColor,
          actions: [
            TextButton(
                onPressed: () async {
                  final SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setBool("onBoarding", false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                child: Text("Skip",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainDarkColor,
                    )))
          ],
        ),
        backgroundColor: AppColors.bgLightColor,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {});
                  if (index == 2) {
                    isLastPage = true;
                  } else {
                    isLastPage = false;
                  }
                },
                controller: pageController,
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SmoothPageIndicator(
                    effect: JumpingDotEffect(
                      paintStyle: PaintingStyle.stroke,
                      activeDotColor: AppColors.mainDarkColor,
                      dotColor: AppColors.mainLightColor,
                    ),
                    controller: pageController,
                    count: boarding.length,
                  ),
                  Spacer(),
                  FloatingActionButton(
                    foregroundColor: AppColors.bgLightColor,
                    shape: CircleBorder(),
                    backgroundColor: AppColors.color6,
                    onPressed: () async {
                      // print(isLastPage);
                      if (isLastPage) {
                        final SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("onBoarding", false);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      } else {
                        pageController.nextPage(
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          curve: Curves.easeInOutSine,
                        );
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
