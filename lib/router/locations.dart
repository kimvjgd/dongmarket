import 'package:beamer/beamer.dart';
import 'package:dongmarket/screens/home_screen.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }

  @override
  List get pathBlueprints => ['/'];
}