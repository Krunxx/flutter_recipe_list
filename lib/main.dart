import 'package:flutter/material.dart';
import 'package:flutter_recipe/add_screen.dart';
import 'package:flutter_recipe/view_screen.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
