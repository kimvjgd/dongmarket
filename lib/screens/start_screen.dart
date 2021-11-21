import 'package:dongmarket/screens/start/address_page.dart';
import 'package:dongmarket/screens/start/auth_page.dart';
import 'package:dongmarket/screens/start/intro_page.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          // physics: NeverScrollableScrollPhysics(),      // 손으로 스크롤해서 다음 페이지로 넘기는 것을 방지해준다.
          controller: _pageController,
          children: [IntroPage(_pageController), AddressPage(), AuthPage()]),
    );
  }
}
