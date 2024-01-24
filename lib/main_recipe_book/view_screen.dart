import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/view_recipe/view_recipe.dart';
import 'package:http/http.dart' as http;

import '../custom_api/custom_api.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late List<Map<String, dynamic>> records = [];
  List record = [];
  String? userId;
  TextEditingController searchController = TextEditingController();
  String uri = ApiUrls.viewRecipe;
  double searchFieldOpacity = 1.0;

  Future<void> getImagesFromDB() async {
    try {
      var response = await http.get(Uri.parse(ApiUrls.viewRecipe));

      setState(() {
        record =
            records = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } catch (e) {
      print(e);
    }
  }

  void _runFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isNotEmpty) {
        record = records
            .where((record) => record["rd_name"]
            .toLowerCase()
            .contains(searchTerm.toLowerCase()))
            .toList();
      } else {
        // If the search term is empty, show all records
        record = List.from(records);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getImagesFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            // Adjust opacity based on scroll position
            setState(() {
              searchFieldOpacity =
                  1.0 - (scrollInfo.metrics.pixels / 50);
              searchFieldOpacity =
                  searchFieldOpacity.clamp(0.0, 1.0); // Ensure opacity is between 0 and 1
            });
          }
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Opacity(
                opacity: searchFieldOpacity,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    labelText: 'Search ',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (searchController.text.isNotEmpty && record.isEmpty)
                Text('No result found for "${searchController.text}"'),
              if (searchController.text.isNotEmpty && record.isNotEmpty)
                Text('Search results for "${searchController.text}"'),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: List.generate(record.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewRecipe(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Ink.image(
                            image: NetworkImage(
                                ApiUrls.baseUrl + record[index]["rd_image"]),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            record[index]["rd_name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
