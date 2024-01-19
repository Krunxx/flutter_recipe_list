// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/recipe_db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Controllers/controllers.dart';
import 'package:http/http.dart' as http;

class add_screen extends StatefulWidget {
  const add_screen({Key? key}) : super(key: key);

  @override
  State<add_screen> createState() => _add_screenState();
}

class _add_screenState extends State<add_screen> {

  Future<void> uploadRecipe() async {
    if (Controller.name.text != "" &&
        Controller.ingradient.text != "" &&
        Controller.time.text != "" &&
        Controller.instruction.text != "")
    {
      String url = "http://192.168.254.105/recipe_api/imageupload.php";
      var req = await http.post(Uri.parse(url), body: {
        "imagename": Controller.imagename,
        "imagedata": Controller.imagedata,
        "name": Controller.name.text,
        "ingradient": Controller.ingradient.text,
        "time": Controller.time.text,
        "instruction": Controller.instruction.text
      });

      print(req);
      print(Controller.imagedata);
      print(Controller.imagename);
      print(Controller.name.text);
      print(Controller.ingradient.text);
      print(Controller.time.text);
      print(Controller.instruction.text);

      int result = jsonDecode(req.body);

      if (result != 0) {
        Fluttertoast.showToast(msg: "Success Uploaded");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {
        Fluttertoast.showToast(msg: "some issue");
      }
    } else {
      Fluttertoast.showToast(msg: "Fill All Field");
    }
  }

  Future<void> uploadRecipeDb() async {
    if (Controller.name.text != "" &&
        Controller.ingradient.text != "" &&
        Controller.time.text != "" &&
        Controller.instruction.text != "") {

      Map<String, dynamic> recipe = {
        'name': Controller.name.text,
        'ingradient': Controller.ingradient.text,
        'time': Controller.time.text,
        'instruction': Controller.instruction.text,
        'imagePath': Controller.imagename ?? '',
      };

      int result = await RecipeDatabaseHelper.insertRecipe(recipe);

      if (result != 0) {
        Fluttertoast.showToast(msg: "Success Uploaded");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {
        Fluttertoast.showToast(msg: "Some issue");
      }
    } else {
      Fluttertoast.showToast(msg: "Fill All Fields");
    }
  }

  Future<void> getImage() async {
    var getImage = await Controller.imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      Controller.imagepath = File(getImage!.path);
      Controller.imagename = getImage.path.split('/').last;
      Controller.imagedata = base64Encode(Controller.imagepath!.readAsBytesSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        title: const Text("Add Recipe"),
        automaticallyImplyLeading: false,  //pampawala sa automatic back <-
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: Controller.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the recipe name')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.ingradient,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the ingradients')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.time,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the total time')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.instruction,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the instrcutions')),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    getImage();
                   print('work');
                  },
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert),
                      ),
                      Text('ATTACHED IMAGE')
                    ],
                  )),
              Controller.imagepath != null
                  ? Image.file(Controller.imagepath!)
                  : Text('Image Not Choose Yet'),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    setState(() {
                      uploadRecipe();
                      uploadRecipeDb();
                    });
                  },
                  child: Text('Upload')),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}
