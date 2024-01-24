import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/color_theme/color_theme.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/update_recipe/update_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../custom_api/custom_api.dart';

class ViewRecipe extends StatefulWidget {
  final String? image, name, ind, time, ins, id;

  ViewRecipe(this.id, this.image, this.name, this.ind, this.time, this.ins);

  @override
  State<ViewRecipe> createState() =>
      _ViewRecipeState(id, image, name, ind, time, ins);
}

class _ViewRecipeState extends State<ViewRecipe> {
  final String? id, image, name, ind, time, ins;

  _ViewRecipeState(
      this.id, this.image, this.name, this.ind, this.time, this.ins);

  Future<Map<String, dynamic>> fetchData() async {
    await Future.delayed(Duration(seconds: 4));

    var response = await http.get(Uri.parse(ApiUrls.baseUrl + image!));
    return {'imageData': response.bodyBytes};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainTheme,
      appBar: AppBar(
        backgroundColor: CustomTheme.headerTheme,
        foregroundColor: Colors.black,
        title: const Text("Recipe Details"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => update_screen(id!, image!, name!, ind!, time!, ins!),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              // Show a confirmation dialog
              bool confirmDelete = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this ' + name! + ' recipe?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // User doesn't want to delete
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User confirms delete
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              // If user confirms delete, proceed with deletion
              if (confirmDelete == true) {
                try {
                  var response = await http.post(Uri.parse(ApiUrls.deleteRecipe), body: {"id": id!});
                  var res = jsonDecode(response.body);
                  if (res["success"] == "true") {
                    Fluttertoast.showToast(msg: "Success Delete");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                  } else {
                    Fluttertoast.showToast(msg: "Some issue");
                  }
                } catch (e) {
                  print(e);
                }
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var imageData = snapshot.data!['imageData'];
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.memory(
                        imageData,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Recipe Name : ' + name!,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Preparation Time : ' + time!,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ingredients : ' + ind!,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Instructions : ' + ins!,
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
