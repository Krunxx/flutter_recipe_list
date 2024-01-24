import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/authentication/register.dart';
import 'package:flutter_recipe/authentication/user_preferences/user_preferences.dart';
import 'package:flutter_recipe/main.dart';
import '../Controllers/controllers.dart';
import 'package:http/http.dart' as http;
import '../color_theme/color_theme.dart';
import '../custom_api/custom_api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passenable = true;
  String uri = ApiUrls.login;

  Future<void> postLogin() async {
    // print console terminal
    print('nara lods email: ${Controller.reg_username.text}');
    print('nara lods password: ${Controller.password.text}');
    final response = await http.post(
      Uri.parse(ApiUrls.login),
      body: {
        'email': Controller.email.text,
        'username': Controller.username.text,
        'password': Controller.password.text,
      },
    );

    if (response.statusCode == 200) {
      var resBodyOfLogin = jsonDecode(response.body);
      if (resBodyOfLogin['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Log in successfully 🎉")));

        await RememberUserPreferences.storeUserInfo(resBodyOfLogin["userData"]);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    }
  }

  Future<void> clearText() async {
    Controller.password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainTheme,
      appBar: AppBar(
        backgroundColor: CustomTheme.mainTheme,
        foregroundColor: Colors.black,
        title: const Text("LOGIN"),
        automaticallyImplyLeading: false,
        //pampawala sa automatic back <-
        elevation: 0,
        // remove bottom shadow sa appbar
        actions: const [],
      ),
      body: Form(
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
                    'assets/logo.png',
                    width: 150, // Set the width of the image
                    height: 150, // Set the height of the image
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: Controller.email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter the email'),
                    filled: true,
                    fillColor: Colors.white, // Set the background color to white
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
                  obscureText: passenable,
                  //if passenable == true, show **, else show password character
                  controller: Controller.password,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Enter the password",
                    suffix: IconButton(
                        onPressed: () {
                          //add Icon button at end of TextField
                          setState(() {
                            //refresh UI
                            if (passenable) {
                              //if passenable == true, make it false
                              passenable = false;
                            } else {
                              passenable =
                                  true; //if passenable == false, make it true
                            }
                          });
                        },
                        icon: Icon(passenable == true
                            ? Icons.remove_red_eye_outlined
                            : Icons.password)),
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
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    postLogin();
                    clearText();
                  },
                  child: Text("Login"),
                ),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(500, 50)),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.black)),
                        // Set the outline color
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      });
                    },
                    child: Text("Register")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
