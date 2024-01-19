import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Controller{
  static TextEditingController name = new TextEditingController();
  static TextEditingController ingradient = new TextEditingController();
  static TextEditingController time = new TextEditingController();
  static TextEditingController instruction = new TextEditingController();
  static TextEditingController username = new TextEditingController();
  static TextEditingController password = new TextEditingController();
  static File? imagepath;

  static String? imagename;
  static String? imagedata;

  static ImagePicker imagePicker = new ImagePicker();

}