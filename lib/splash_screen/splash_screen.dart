import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    //TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", height: 130,),
            const SizedBox(height: 30,),
            const CircularProgressIndicator(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

