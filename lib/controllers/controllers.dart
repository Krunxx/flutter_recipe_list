import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Controller{
  static TextEditingController name = new TextEditingController();
  static TextEditingController ingradient = new TextEditingController();
  static TextEditingController time = new TextEditingController();
  static TextEditingController instruction = new TextEditingController();
  static TextEditingController username = new TextEditingController();
  static TextEditingController email = new TextEditingController();
  static TextEditingController password = new TextEditingController();
  static TextEditingController reg_username = new TextEditingController();
  static TextEditingController reg_email = new TextEditingController();
  static TextEditingController reg_password = new TextEditingController();
  static File? imagepath;

  static String? imagename;
  static String? imagedata;

  static ImagePicker imagePicker = new ImagePicker();
}
// Guide
/*
The Controller class is defined to manage all the input and data used in the app.

First, several TextEditingController objects are defined.
These objects are used to manage the text entered into TextField widgets in Flutter.
When a TextField widget is wrapped in a Form widget, it needs a TextEditingController to handle user input.

The ImagePicker object is created to handle the image selection process.

The imagepath variable is defined to store the local file path of the selected image.

The imagename, imagedata, and imagename variables are used to store the
image's name, data, and data length, respectively. These variables can be used to upload the image to a server.

To select an image from the device gallery, the pickImage function from the ImagePicker
 package can be used. The pickImage function returns a PickedFile object that contains
 the image file and its path. The selected image can then be stored in the imagepath
 variable and converted to base64 format for further processing.

This code serves as a base for the state management in the app.
It is typically used in conjunction with other state management techniques or tools like Provider, Bloc, or GetX.
 */