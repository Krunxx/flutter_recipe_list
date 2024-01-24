/*
This line imports the dart:convert library, which provides functions
for converting between different data representations, such as JSON and Dart objects.
 */
import 'dart:convert';
/*
This line imports the Flutter material design library,
which provides a set of widgets that implement Material Design guidelines.
 */
import 'package:flutter/material.dart';
/*
This line imports the http package, which provides functions for making HTTP requests
 */
import 'package:http/http.dart' as http;
/*
This line imports a custom file named controllers.dart
from the Controllers directory. This file likely contains classes
or functions for controlling the app's business logic.
 */
import '../Controllers/controllers.dart';
/*
This line imports a custom file named login.dart from the authentication
directory. This file likely contains a widget for the app's login screen.
 */
import '../authentication/login.dart';
/*
 This line imports a custom file named color_theme.dart from the color_theme directory.
 This file likely defines custom color themes for the app.
 */
import '../color_theme/color_theme.dart';
/*
This line imports a custom file named custom_api.dart from the custom_api directory.
This file likely contains custom API services for the app.
 */
import '../custom_api/custom_api.dart';

/*
his line defines a new Flutter widget named Register.
This widget is a StatefulWidget, which means it can maintain its own state.
 */
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  /*
  This line declares a private final variable named _formKey of type
  GlobalKey<FormState>. This variable is used to validate the form when the user submits it.
   */
  final _formKey = GlobalKey<FormState>();

  /*
  This line declares a private variable named _passenable of type bool.
  This variable is used to toggle the visibility of the password field.
   */
  late bool _passenable = true;

  /*
  This line declares a private final variable named _validate of type bool.
   This variable is used to control form validation.
   */
  final bool _validate = false;

  /*
  This line declares a private final variable named uri of type String.
  This variable is used to store the API endpoint for registering a new user.
   */
  final String uri = ApiUrls.register;
  /*
  This is a method that sends an HTTP POST request to the API endpoint
  to register a new user.
  It takes the username, email, and password
  from the Controller class and sends them to the API.
   */
  Future<void> insertRecord() async {
    if (Controller.reg_email.text != "" ||
        Controller.reg_username.text != "" ||
        Controller.reg_password.text != "") {
      try {
        var res = await http.post(Uri.parse(ApiUrls.register), body: {
          "username": Controller.reg_username.text,
          "email": Controller.reg_email.text,
          "password": Controller.reg_password.text,
        });

        var response = jsonDecode(res.body);
        if (response != 0) {
          print("work well");
        } else {
          print("some issue");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Please fill all fields");
    }
  }

  // Obvious method nga i clear ang input
  Future<void> clearText() async {
    Controller.reg_email.clear();
    Controller.reg_username.clear();
    Controller.reg_password.clear();
  }

  /*
   This is the build method for the Register widget. It returns a Scaffold widget, which is a basic Flutter layout widget.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainTheme,
      appBar: AppBar(
        backgroundColor: CustomTheme.mainTheme,
        foregroundColor: Colors.black,
        title: const Text("REGISTER"),
        automaticallyImplyLeading: false,
        //pampawala sa automatic back <-
        elevation: 0,
        // remove bottom shadow sa appbar
        actions: const [],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    'assets/register.png',
                    width: 150, // Set the width of the image
                    height: 150, // Set the height of the image
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: Controller.reg_username,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the username'),
                    filled: true,
                    fillColor: Colors.white,
                    // Set the background color to white
                    suffixIcon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.grey, // Customize the color of your icon
                    ),
                  ),
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
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: Controller.reg_email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the email'),
                    filled: true,
                    fillColor: Colors.white,
                    // Set the background color to white
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                  ),
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
                TextField(
                  obscureText: _passenable,
                  //if passenable == true, show **, else show password character
                  controller: Controller.reg_password,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Enter the password",
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      suffix: IconButton(
                          onPressed: () {
                            //add Icon button at end of TextField
                            setState(() {
                              //refresh UI
                              if (_passenable) {
                                //if passenable == true, make it false
                                _passenable = false;
                              } else {
                                _passenable =
                                    true; //if passenable == false, make it true
                              }
                            });
                          },
                          icon: Icon(_passenable == true
                              ? Icons.remove_red_eye_outlined
                              : Icons.password))
                      //eye icon if passenable = true, else, Icon is ***__
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(500, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            CustomTheme.login_register_button_theme),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        insertRecord();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registered !')),
                        );
                      }
                      // clearText();
                    },
                    child: Text("Register")),
                SizedBox(
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
                      clearText();
                    },
                    child: Text("Clear")),
                SizedBox(
                  height: 10,
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
                    child: Text("Back")),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
