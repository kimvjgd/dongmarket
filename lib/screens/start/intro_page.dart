import 'package:dio/dio.dart';
import 'package:dongmarket/constants/common_size.dart';
import 'package:dongmarket/states/user_provider.dart';
import 'package:dongmarket/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class IntroPage extends StatelessWidget {
  IntroPage(this.controller, {Key? key}) : super(key: key);

  PageController controller;

  @override
  Widget build(BuildContext context) {
    logger.d('current user state: ${context.read<UserProvider>().userState}');
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        final imgSize = size.width-32;
        final sizeOfPosImg = imgSize * 0.1;


        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: common_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '토마토마켓',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: Stack(
                    children: [
                      ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                      Positioned(
                          width: sizeOfPosImg,
                          height: sizeOfPosImg,
                          left: imgSize * 0.45,
                          top: imgSize * 0.45,
                          child: ExtendedImage.asset('assets/imgs/carrot_intro_pos.png')),
                    ],
                  ),
                ),
                Text(
                  '우리 동네 중고 직거래 토마토마켓',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '토마토마켓은 동네 직거래 마켓이에요.\n 내 동네를 설정 후 시작해보세요',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () async{
                        controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        logger.d('on text button clicked!!');
                      },
                      child: Text('내 동네 설정하고 시작하기',
                          style: Theme.of(context).textTheme.button),
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
