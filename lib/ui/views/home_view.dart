import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:renty_crud_version/services/authentication_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFloatingBar(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildFloatingBar() {
    return FloatingSearchBar.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Text(index.toString()),
        );
      },
      trailing: CircleAvatar(
        //TODO: Insert current user avatar.
        // child: Text("MP"),
        child: Icon(Icons.face),
      ),
      drawer: Drawer(
        child: _buildSideBar(),
      ),
      onChanged: (String value) {},
      onTap: () {},
      decoration: InputDecoration.collapsed(
        hintText: "Search what you want!",
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return FancyBottomNavigation(
      circleColor: Colors.pink,
      activeIconColor: Colors.white,
      inactiveIconColor: Colors.black,
      tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.pan_tool, title: "Lend my Item"),
        TabData(iconData: Icons.receipt, title: "My Rented Items")
      ],
      onTabChangedListener: (position) {
        setState(() {
          //currentPage = position;
        });
      },
    );
  }

  Widget _buildSideBar() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    '/assets/splashlogo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Firstname Lastname",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "user@email.com",
                  style: TextStyle(color: Colors.white),
                ),
                //Build Stepper Here
                Text('Account Verification Status',
                    style: TextStyle(color: Colors.white)),
                //_buildAccountStepper(value),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Transactions History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Logout'),
            onTap: () async {
              FirebaseAuth _auth;
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }

  void setState(Null Function() param0) {}
}
