// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:flutter_recipe/view_recipe.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class update_screen extends StatefulWidget {
  String? image, name, ind, time, ins, id;
  update_screen(this.id, this.image, this.name, this.ind, this.time, this.ins);

  @override
  State<update_screen> createState() =>
      _update_screenState(id, image, name, ind, time, ins);
}

class _update_screenState extends State<update_screen> {
  String? image, nam, ind, tim, ins, id;
  _update_screenState(
      this.id, this.image, this.nam, this.ind, this.tim, this.ins);

  TextEditingController name = new TextEditingController();
  TextEditingController ingradient = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController instruction = new TextEditingController();
  File? imagepath;

  String? imagename;
  String? imagedata;
  @override
  void initState() {
    // TODO: implement initState
    name.text = nam!;
    ingradient.text = ind!;
    time.text = tim!;
    instruction.text = ins!;
    super.initState();
  }

  ImagePicker imagePicker = new ImagePicker();

  Future<void> updateimage() async {
    if (name.text != "" &&
        ingradient.text != "" &&
        time.text != "" &&
        instruction.text != "") {
      String url = "http://192.168.254.105/recipe_api/update_image.php";
      var req = await http.post(Uri.parse(url), body: {
        "imagename": imagename,
        "imagedata": imagedata,
        "name": name.text,
        "ingradient": ingradient.text,
        "time": time.text,
        "instruction": instruction.text,
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
              imagepath != null
                  ? Image.file(imagepath!)
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
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    setState(() {
                      updateimage();
                    });
                  },
                  child: Text('Update')),
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
