import 'package:flutter/material.dart';
import 'package:todo/presentation/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    waitSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/splash.gif"),
          radius: 50,
        ),
      ),
    );
  }

  Future<void> waitSplash() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }
}
