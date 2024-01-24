import 'package:flutter/material.dart';
import 'package:flutter_recipe/controllers/controllers.dart';

import 'package:flutter_recipe/color_theme/color_theme.dart';

import 'package:flutter_recipe/authentication/login.dart';
import 'package:flutter_recipe/main.dart';

class DrawerNav extends StatefulWidget {
  final String? email, username;

  const DrawerNav(this.email, this.username, {super.key});

  @override
  State<DrawerNav> createState() => _DrawerNavState(email, username);
}

class _DrawerNavState extends State<DrawerNav> {
  final String? email, username;

  _DrawerNavState(this.email, this.username);

  @override
  void initState() {
  // TODO: implement initState
  Controller.email.text = email!;
  Controller.username.text = username!;
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomTheme.mainTheme,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(Controller.email.text),
            accountEmail: Text(Controller.username.text),
            // currentAccountPicture: CircleAvatar(
            //   child: Image.asset(
            //     'assets/profile.png',
            //     // Replace with the path to your image asset
            //     width: 150, // Set the width of the image
            //     height: 150, // Set the height of the image
            //   ),
            // ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              // Show a confirmation dialog
              bool confirmLogout = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // User doesn't want to logout
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User confirms logout
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );

              // If user confirms logout, proceed with logout
              if (confirmLogout == true) {
                // Perform logout actions here, such as clearing user data
                // Navigator.pushReplacement should navigate to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
