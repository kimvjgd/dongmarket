import 'package:beamer/beamer.dart';
import 'package:dongmarket/router/locations.dart';
import 'package:dongmarket/screens/start_screen.dart';
import 'package:dongmarket/screens/splash_screen.dart';
import 'package:dongmarket/states/user_provider.dart';
import 'package:dongmarket/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return context.watch<UserProvider>().userState;
        // return context.read<UserProvider>().userState;     <= listen: false
        // return context.watch<UserProvider>().userState;    <= listen: true
      },
      showPage: BeamPage(child: StartScreen()))
], locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()]));

void main() {
  logger.d('my first log by logger!~');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 500), () => 100),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            child: _splashLoadingWidget(snapshot),
            duration: Duration(milliseconds: 300),
          );
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      print('error');
      return Text('error occur');
    } else if (snapshot.hasData) {
      return TomatoApp();
    } else {
      return SplashScreen();
    }
  }
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) {
          return UserProvider();
        },
        child: MaterialApp.router(
            theme: ThemeData(
                primarySwatch: Colors.orange,
                fontFamily: 'Donghyun',
                hintColor: Colors.grey[350],
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        primary: Colors.white,
                        minimumSize: Size(48, 48))),
                textTheme: TextTheme(
                    headline3: TextStyle(fontFamily: 'Donghyun'),
                    button: TextStyle(color: Colors.white)),
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.white,
                    titleTextStyle: TextStyle(color: Colors.black87),
                    actionsIconTheme: IconThemeData(color: Colors.black))),
            routeInformationParser: BeamerParser(), // beamer가 알아서 해주는 설정 parser
            routerDelegate:
                _routerDelegate)); // 우리가 beamer한테 다 맡기기로 했는데 여기에다 전달해줘라 _routeDelegate는 꼭 global 변로 만들어줘라
  }
}
