// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/view_recipe/view_recipe.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Controllers/controllers.dart';

class update_screen extends StatefulWidget {
  String? image, name, ind, time, ins, id;
  update_screen(this.id, this.image, this.name, this.ind, this.time, this.ins);

  @override
  State<update_screen> createState() => _update_screenState(id, image, name, ind, time, ins);
}

class _update_screenState extends State<update_screen> {
  String? image, nam, ind, tim, ins, id;
  _update_screenState(
      this.id, this.image, this.nam, this.ind, this.tim, this.ins);


  @override
  void initState() {
    // TODO: implement initState
    Controller.name.text = nam!;
    Controller.ingradient.text = ind!;
    Controller.time.text = tim!;
    Controller.instruction.text = ins!;
    super.initState();
  }

  Future<void> uploadRecipe() async {
    if (Controller.name.text != "" &&
        Controller.ingradient.text != "" &&
        Controller.time.text != "" &&
        Controller.instruction.text != "") {
      String url = "http://192.168.254.105/recipe_api/update_image.php";
      var req = await http.post(Uri.parse(url), body: {
        "imagename": Controller.imagename,
        "imagedata": Controller.imagedata,
        "name": Controller.name.text,
        "ingradient": Controller.ingradient.text,
        "time": Controller.time.text,
        "instruction": Controller.instruction.text,
        "id": id
      });

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
          title: const Text("Update Recipe"),
          actions: const [],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
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
                    label: Text('Enter the instructions')),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    getImage();

//                    print('work');
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
                  : Ink.image(
                      image:
                          NetworkImage("http://192.168.254.105/recipe_api/" + image!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
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
                    });
                  },
                  child: Text('Update')),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
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
