import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_recipe/add_recipe/add_screen.dart';
import 'package:flutter_recipe/main_recipe_book/view_screen.dart';
import 'package:flutter_recipe/splash_screen/splash_screen.dart';

void main() {
  runApp(
      MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      )
  );
=======
import 'package:flutter_recipe/add_screen.dart';
import 'package:flutter_recipe/view_screen.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
>>>>>>> f68292203b6a8c639d99ea188471c61d9b5a31b3
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        title: const Text("Recipe Book"),
        actions: const [],
        automaticallyImplyLeading: false,

      ),
      floatingActionButton: FloatingActionButton.extended(

          icon: Icon(Icons.add),
          label: Text('Add Recipe'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
=======
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Recipe Book"),
        actions: const [],
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Recipe'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
>>>>>>> f68292203b6a8c639d99ea188471c61d9b5a31b3
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => add_screen(),
                ));
          }),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ViewScreen(),
      ),
    );
  }
}
