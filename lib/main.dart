import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_recipe/Controllers/controllers.dart';
import 'package:flutter_recipe/add_recipe/add_screen.dart';
import 'package:flutter_recipe/main_recipe_book/view_screen.dart';
import 'package:flutter_recipe/splash_screen/splash_screen.dart';
import 'package:flutter_recipe/drawer_navigation//navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication/login.dart';
import 'color_theme/color_theme.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  late List<Map<String, dynamic>>
      records; // Updated to use Map<String, dynamic>
  List record = [];
  String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainTheme,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Recipe"),
        backgroundColor: CustomTheme.headerTheme,
        foregroundColor: Colors.black,
        actions: const [],
        elevation: 0,
      ),

      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ViewScreen(),
      ),

      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Recipe'),
          backgroundColor: CustomTheme.buttonTheme,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddRecipeScreen(),
                ));
          }),

      drawer: DrawerNav('${Controller.reg_email.text}', '${Controller.reg_username.text}'),
    );
  }
}

