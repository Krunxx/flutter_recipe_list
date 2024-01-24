//In this code, a splash screen is implemented in Flutter using the StatefulWidget and initState() methods.
//The necessary packages are imported, including the Flutter Material package and the Login page shared preference.
import 'package:flutter/material.dart';
import 'package:flutter_recipe/color_theme/color_theme.dart';
import '../authentication/login.dart';

/*
The SplashScreen class extends StatefulWidget
 and defines a method to create the corresponding state, which is _SplashScreenState.
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/*
The _SplashScreenState class is the private State class that holds the mutable data of the Splash Screen.
 */
class _SplashScreenState extends State<SplashScreen> {
  /*
  In the initState() method, the super.initState() call is
  used to initialize the framework, followed by the use of Future.delayed().
   This function creates a delay of 5 seconds before executing the code
   within its parentheses. Inside the parentheses,
   Navigator.pushReplacement() is used to replace the Splash Screen with the Login page after the delay.
   */
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  //In the build() method, a Scaffold widget is used to define the
  //overall structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The background color is set using Color.fromRGBO().
      backgroundColor: CustomTheme.mainTheme,
      body: Center(
        /*
        A Column widget is used to vertically align the child widgets,
        including the logo image, a sized box for spacing, and a CircularProgressIndicator.
         */
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            The logo image is displayed using the Image.asset() function,
             which loads the image from the specified asset path.
             */
            Image.asset(
              "assets/logo.png",
              height: 130,
            ),
            const SizedBox(
              height: 30,
            ),
            /*
            The CircularProgressIndicator widget is displayed
            while the Splash Screen is active.
            The color of the circular progress indicator
             is set to black using the color property.
             */
            const LinearProgressIndicator(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

/*
 DIFFERENCE BETWEEN  initState()  super.initState()

 initState() = is a lifecycle method in Flutter that is
 called exactly once in the lifetime of a State object, and it is
 used to perform one-time initialization tasks.

 initState() = is a user-defined method used to initialize the state of the widget,

 The super.initState() call in the initState() method is used to
 ensure that the framework's initialization is completed before any
 custom initialization is performed.

 super.initState() is a call to the superclass's implementation of the
 initState() method.
 */
