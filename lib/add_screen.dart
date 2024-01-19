// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/recipe_db.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class add_screen extends StatefulWidget {
  const add_screen({Key? key}) : super(key: key);

  @override
  State<add_screen> createState() => _add_screenState();
}

class _add_screenState extends State<add_screen> {
  TextEditingController name = new TextEditingController();
  TextEditingController ingradient = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController instruction = new TextEditingController();
  File? imagepath;

  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = new ImagePicker();

  Future<void> uploadimage() async {
    if (name.text != "" &&
        ingradient.text != "" &&
        time.text != "" &&
        instruction.text != "") {
      String url = "http://192.168.254.105/recipe_api/imageupload.php";
      var req = await http.post(Uri.parse(url), body: {
        "imagename": imagename,
        "imagedata": imagedata,
        "name": name.text,
        "ingradient": ingradient.text,
        "time": time.text,
        "instruction": instruction.text
      });

      print(req);
      print(imagedata);
      print(imagename);
      print(name.text);
      print(ingradient.text);
      print(time.text);
      print(instruction.text);

      var res = jsonDecode(req.body);

      if (res["success"] == "true") {
        Fluttertoast.showToast(msg: "Success Uploaded");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {
        Fluttertoast.showToast(msg: "some isseu");
      }
    } else {
      Fluttertoast.showToast(msg: "Fill All Field");
    }
  }

  Future<void> uploadimagelocaldb() async {
    if (name.text != "" &&
        ingradient.text != "" &&
        time.text != "" &&
        instruction.text != "") {

      Map<String, dynamic> recipe = {
        'name': name.text,
        'ingradient': ingradient.text,
        'time': time.text,
        'instruction': instruction.text,
        'imagePath': imagename ?? '',
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


  Future<void> getimage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imagepath = File(getImage!.path);
      imagename = getImage.path.split('/').last;
      // sdcard/downlaod/abc.png
      imagedata = base64Encode(imagepath!.readAsBytesSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Add Recipe"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the recipe name')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: ingradient,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the ingradients')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: time,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the total time')),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: instruction,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the instrcutions')),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    getimage();

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
              imagepath != null
                  ? Image.file(imagepath!)
                  : Text('Image Not Choose Yet'),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    setState(() {
                      uploadimage();
                      uploadimagelocaldb();
                    });
                  },
                  child: Text('Upload')),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
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
