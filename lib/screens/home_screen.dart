import 'package:dongmarket/states/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          context.read<UserProvider>().setUserAuth(false);
        }, icon: Icon(Icons.logout))],
      ),
    );
  }
}
