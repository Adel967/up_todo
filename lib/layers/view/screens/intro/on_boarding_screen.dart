import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up_todo/core/configuration/assets.dart';
import 'package:up_todo/core/shared_preference_key.dart';
import 'package:up_todo/layers/view/screens/intro/welcome_screen.dart';

import '../../../../core/constants/theme.dart';
import '../../../models/first_open_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _pageControllerForImage;
  late PageController _pageControllerForContent;
  int index1 = 0;
  List<FirstOpenModel> screens = <FirstOpenModel>[
    FirstOpenModel(
        img: Assets.ONBOARDING1_ICON,
        text: "Manage your tasks",
        desc: "You can easily manage all of your daily tasks in DoMe for free"),
    FirstOpenModel(
        img: Assets.ONBOARDING2_ICON,
        text: "Create daily routine",
        desc:
            "In Uptodo  you can create your personalized routine to stay productive"),
    FirstOpenModel(
        img: Assets.ONBOARDING3_ICON,
        text: "Orgonaize your tasks",
        desc:
            "You can organize your daily tasks by adding your tasks into separate categories"),
  ];

  navigateToNextScreen() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => WelcomeScreen()));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferencesKeys.FIRST_TIME_KEY, false);
  }

  previousPage() {
    _pageControllerForImage.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
    _pageControllerForContent.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  nextPage() {
    _pageControllerForImage.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
    _pageControllerForContent.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  void initState() {
    _pageControllerForImage = PageController(initialPage: 0);
    _pageControllerForContent = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageControllerForImage.dispose();
    _pageControllerForContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                TextButton(
                    onPressed: () => navigateToNextScreen(),
                    child: Text(
                      "SKIP",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              itemCount: screens.length,
                              controller: _pageControllerForImage,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: (int index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (_, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      screens[index].img,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 4.0,
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: ListView.builder(
                            itemCount: screens.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                width: 26,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Color(0XFFFFFFFF)
                                      : Color(0xFFAFAFAF),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                              itemCount: screens.length,
                              controller: _pageControllerForContent,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: (int index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (_, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      screens[index].text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 260,
                                      child: Text(
                                        screens[index].desc,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Lato',
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        currentIndex != 0
                            ? TextButton(
                                onPressed: () {
                                  currentIndex--;
                                  previousPage();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Back",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  ],
                                ))
                            : SizedBox(),
                        TextButton(
                          child: Text(
                            "NEXT",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ThemeColors.secondary),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () {
                            if (currentIndex == screens.length - 1) {
                              navigateToNextScreen();
                              return;
                            }
                            setState(() {
                              currentIndex++;
                            });
                            nextPage();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
