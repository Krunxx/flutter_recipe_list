import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Controllers/controllers.dart';
import '../color_theme/color_theme.dart';
import '../custom_api/custom_api.dart';

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

  String uri = ApiUrls.updateRecipe;

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

      var req = await http.post(Uri.parse(ApiUrls.updateRecipe), body: {
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
        Fluttertoast.showToast(msg: "Update Successfully 🎉");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {
        Fluttertoast.showToast(msg: "some isseu");
      }
    } else {
      Fluttertoast.showToast(msg: "Fill All Field");
    }
  }

  Future<void> getImageCamera() async {
    var getImage =
    await Controller.imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      Controller.imagepath = File(getImage!.path);
      Controller.imagename = getImage.path.split('/').last;
      Controller.imagedata =
          base64Encode(Controller.imagepath!.readAsBytesSync());
    });
  }

  Future<void> getImageGallery() async {
    var getImage =
    await Controller.imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      Controller.imagepath = File(getImage!.path);
      Controller.imagename = getImage.path.split('/').last;
      Controller.imagedata =
          base64Encode(Controller.imagepath!.readAsBytesSync());
    });
  }

  @override
  Widget _buildCancelButton() {
    if (Controller.imagepath != null) {
      return IconButton(
        onPressed: () {
          setState(() {
            Controller.imagepath = null;
            Controller.imagename = '';
            Controller.imagedata = '';
          });
        },
        icon: Icon(Icons.close),
      );
    } else {
      return SizedBox.shrink(); // Invisible widget if no image is attached
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:CustomTheme.mainTheme,
      appBar: AppBar(
          backgroundColor:CustomTheme.headerTheme,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the recipe name')),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.ingradient,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the ingredients')),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.time,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the total time')),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Controller.instruction,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the instructions')),
              ),                const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      print('Camera');
                    },
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera),
                        ),
                        Text('CAMERA'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      print('Gallery');
                    },
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.photo),
                        ),
                        Text('GALLERY'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  _buildCancelButton(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Controller.imagepath != null
                  ? Image.file(Controller.imagepath!)
                  : Text('Image Not Chosen Yet'),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(500, 50)),
                      backgroundColor: MaterialStateProperty.all(CustomTheme.buttonTheme),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    setState(() {
                      uploadRecipe();
                    });
                  },
                  child: Text('Update')),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(500, 50)),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.black)),
                      // Set the outline color
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

