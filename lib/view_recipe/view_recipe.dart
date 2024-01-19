import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/update_recipe/update_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class ViewRecipe extends StatefulWidget {
  String? image, name, ind, time, ins, id;
  ViewRecipe(this.id, this.image, this.name, this.ind, this.time, this.ins);

  @override
  State<ViewRecipe> createState() =>
      _ViewRecipeState(id, image, name, ind, time, ins);
}

class _ViewRecipeState extends State<ViewRecipe> {
  String? id, image, name, ind, time, ins;
  _ViewRecipeState(
      this.id, this.image, this.name, this.ind, this.time, this.ins);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        title: const Text("Recipe Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => update_screen(
                            id!, image!, name!, ind!, time!, ins!)));
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                try {
                  var record = "";
                  String uri = "http://192.168.254.105/recipe_api/deleteimage.php";
                  var response =
                      await http.post(Uri.parse(uri), body: {"id": id!});
                  var res = jsonDecode(response.body);
                  if (res["success"] == "true") {
                    Fluttertoast.showToast(msg: "Success Delete");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  } else {
                    Fluttertoast.showToast(msg: "some isseu");
                  }
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink.image(
                  image: NetworkImage("http://192.168.254.105/recipe_api/" + image!),
                  height: 200,
                  fit: BoxFit.cover),
              SizedBox(
                height: 30,
              ),
              Text(
                'Recipe Name : ' + name!,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Preparation Time : ' + time!,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Ingredients : ' + ind!,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Instructions : ' + ins!,
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
        ),
      ),
    );
  }
}
