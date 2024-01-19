import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/recipe_db.dart';
import 'package:flutter_recipe/splash_screen/splash_screen.dart';
import 'package:flutter_recipe/view_recipe/view_recipe.dart';
import 'package:http/http.dart' as http;

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late List<Map<String, dynamic>> records; // Updated to use Map<String, dynamic>
  List record = [];
  var url = "http://192.168.254.105/recipe_api/";


  Future<void> imagefromdb() async {
    try {
      String uri = "http://192.168.254.105/recipe_api/viewimage.php";
      var response = await http.get(Uri.parse(uri));
      setState(() {
        record = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    imagefromdb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1),
        itemCount: record.length,
        itemBuilder: (context, index) {
          return Ink.image(
            image: NetworkImage(
                url + record[index]["rd_image"]),
            height: 200,
            fit: BoxFit.cover,
            // colorFilter: ColorFilters.greyscale,
            child: InkWell(
              onTap:  () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewRecipe(
                                record[index]["rd_id"],
                                record[index]["rd_image"],
                                record[index]["rd_name"],
                                record[index]["rd_ind"],
                                record[index]["rd_time"],
                                record[index]["rd_ins"],

                              ),
                      ),
                  );
              },
            ),
          );

        });
  }
}

