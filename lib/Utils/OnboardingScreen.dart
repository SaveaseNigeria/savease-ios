import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savease/Model/data.dart';
import 'package:savease/Utils/page_indicator.dart';
import 'package:savease/Auth/AuthWelcome.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => new _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin{


  PageController _controller;
  int currentPage = 0;
  bool lastPage = false;
  AnimationController animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/bne.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Center(
                child: PageView.builder(
                  itemCount: pageList.length,
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                      if (currentPage == pageList.length - 1) {
                        lastPage = true;
                        animationController.forward();
                      } else {
                        lastPage = false;
                        animationController.reset();
                      }
                      print(lastPage);
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        var page = pageList[index];
                        var delta;
                        var y = 1.0;

                        if (_controller.position.haveDimensions) {
                          delta = _controller.page - index;
                          y = 1 - delta.abs().clamp(0.0, 1.0);
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 90.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.only(left: 20.0),
                             child: Text(page.body, style: TextStyle(fontSize: 20.0,fontFamily: "sfprodisplayheavy")),
                           ),

                              Expanded(
                                flex: 2,
                                child: Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Center(
                                        child: Container(
                                            width: 200.0,
                                            height: 200.0,
                                            child: SvgPicture.asset(
                                              page.imageUrl,
                                              height: 200.0,
                                            ),),
                                      ),
                                    ),
                              ),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 200.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 34.0, top: 0.0,right: 20.0),
                                      child: Image.asset(page.logo)
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 85.0,
              bottom: 55.0,
              child: Container(
                  width: 140.0,
                  child: PageIndicator(currentPage, pageList.length)),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: lastPage
                    ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
                  },
                )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}