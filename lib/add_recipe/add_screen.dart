import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Controllers/controllers.dart';
import 'package:http/http.dart' as http;
import '../authentication/user_preferences/user_preferences.dart';
import '../color_theme/color_theme.dart';
import '../custom_api/custom_api.dart';
import '../drawer_navigation/navigation_drawer.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String uri = ApiUrls.addRecipe;

  Future<void> uploadRecipe() async {
    if (Controller.name.text != "" &&
        Controller.ingradient.text != "" &&
        Controller.time.text != "" &&
        Controller.instruction.text != "") {
      String? userId;
      try {
        Map<String, dynamic>? userInfo =
            await RememberUserPreferences.readUserInfo();

        userId = userInfo?['user_id'];
      } catch (error) {
        print("Error lods: $error");
      }

      String url = "http://192.168.254.105/recipe_api/imageupload.php"; // previous kay TAGSA2X
      var req = await http.post(Uri.parse(ApiUrls.addRecipe), // NEW
          body: {
        "user_id": userId,
        "imagename": Controller.imagename,
        "imagedata": Controller.imagedata,
        "name": Controller.name.text,
        "ingradient": Controller.ingradient.text,
        "time": Controller.time.text,
        "instruction": Controller.instruction.text
      });

      var res = jsonDecode(req.body);

      if (res["success"] == "true") {
        Fluttertoast.showToast(msg: "Success Uploaded  🎉");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else if (res["message"] == "Recipe with the same name already exists") {
        Fluttertoast.showToast(msg: "Recipe with the same name already exists");
      } else {
        Fluttertoast.showToast(msg: "RECIPE ALREADY EXIST ❌");
      }
    } else {
      Fluttertoast.showToast(msg: "Fill All Field");
    }
  }

  // Future<void> showFluttertoast() async {
  //   if (Controller.name.text != "" &&
  //       Controller.ingradient.text != "" &&
  //       Controller.time.text != "" &&
  //       Controller.instruction.text != "") {
  //     Map<String, dynamic> recipe = {
  //       'name': Controller.name.text,
  //       'ingradient': Controller.ingradient.text,
  //       'time': Controller.time.text,
  //       'instruction': Controller.instruction.text,
  //       'imagePath': Controller.imagename ?? '',
  //     };
  //
  //     int result = await RecipeDatabaseHelper.insertRecipe(recipe);
  //
  //     if (result != 0) {
  //       Fluttertoast.showToast(msg: "Success Uploaded 🎉");
  //       Controller.name.clear();
  //       Controller.ingradient.clear();
  //       Controller.time.clear();
  //       Controller.instruction.clear();
  //       setState(() {
  //         Controller.imagepath = null;
  //         Controller.imagename = '';
  //         Controller.imagedata = '';
  //       });
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => MyApp()));
  //     } else if (result  == "Recipe with the saeme name already exists") {
  //       Fluttertoast.showToast(msg: "Recipe with the same name already exists");
  //     } else {
  //       Fluttertoast.showToast(msg: "some issue");
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: "Fill All Field");
  //   }
  // }

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

  Future<void> clearInput() async{
    Controller.name.clear();
    Controller.ingradient.clear();
    Controller.time.clear();
    Controller.instruction.clear();
    setState(() {
      Controller.imagepath = null;
    });
  }

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
      backgroundColor: CustomTheme.mainTheme,
      appBar: AppBar(
        backgroundColor: CustomTheme.headerTheme,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Add Recipe"),
        elevation: 0,
        actions: const [],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    label: Text('Enter the recipe name'),
                  ),
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
                  decoration: InputDecoration(
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
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
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
                        backgroundColor:
                            MaterialStateProperty.all(CustomTheme.buttonTheme),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      setState(() {
                        uploadRecipe();
                        // showFluttertoast();
                      }
                      );
                    },
                    child: Text('Upload')),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(500, 50)),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.black)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      setState(() {
                        clearInput();
                      });
                    },
                    child: const Text('Clear')),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(500, 50)),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.black)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Cancel')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerNav(
          '${Controller.reg_email.text}', '${Controller.reg_username.text}'),
    );
  }
}
