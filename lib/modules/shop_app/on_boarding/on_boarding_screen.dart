// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_app/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/img/on_board/1.jpg',
        title: 'Enter Your Size',
        body:
            'Will save your time when searching\nAnd buying products. Size is entered beforehand.'),
    BoardingModel(
        image: 'assets/img/on_board/2.jpg',
        title: 'Search Products',
        body:
            'Search through products, select\nProducts you like and add them to cart\nFor checkout and payment.'),
    BoardingModel(
        image: 'assets/img/on_board/3.jpg',
        title: 'Delivery',
        body:
            'From 10 to 15 days your stuff will be\nDelivered to your doorstep.'),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigatorAndFinish(context, LoginScreen(), until: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
              controller: boardController,
              onPageChanged: (index) {
                setState(() {
                  if (index == boarding.length - 1) {
                    isLast = true;
                  } else {
                    isLast = false;
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          SmoothPageIndicator(
            controller: boardController,
            count: boarding.length,
            effect: ExpandingDotsEffect(
              paintStyle: PaintingStyle.fill,
              expansionFactor: 4,
              strokeWidth: 1.5,
              activeDotColor: defaultColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FloatingActionButton(
              //   onPressed: () {
              //   child: Icon(Icons.arrow_forward_ios),
              // ),
              // if(!isLast)
              AnimatedContainer(
                width: isLast ? 0 : 170,
                height: 70,
                duration: Duration(milliseconds: 500),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(200)),
                  ),
                  height: 70,
                  // minWidth: 170,
                  onPressed: () {
                    submit();
                  },
                  color: Colors.grey[300],
                  elevation: 0,
                  textColor: Colors.blueAccent,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: isLast ? 0 : 1,
                    child: Text(
                      'Skip',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Spacer(),
              AnimatedContainer(
                height: 70,
                width: isLast ? 300 : 170,
                duration: Duration(milliseconds: 500),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(200)),
                  ),
                  height: 70,
                  minWidth: isLast ? 300 : 170,
                  onPressed: () {
                    if (!isLast) {
                      boardController.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    } else {
                      submit();
                    }
                  },
                  color: Colors.blue,
                  elevation: 0,
                  textColor: Colors.white,
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        children: [
          Expanded(
            flex: 3,
            child: Image(
              image: AssetImage(model.image),
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${model.title}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${model.body}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
