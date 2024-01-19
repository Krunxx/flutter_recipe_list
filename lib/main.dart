import 'package:flutter/material.dart';
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
