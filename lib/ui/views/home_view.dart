import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/widgets/item_listing_tile.dart';

import 'package:renty_crud_version/viewmodels/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.listenToItemListings(),
      builder: (context, model, child) => Scaffold(
        body: model.items != null
            ? FloatingSearchBar.builder(
                pinned: true,
                itemCount: model.items.length,
                itemBuilder: (context, index) => GestureDetector(
                  //onTap: () => model.editPost(index),
                  child: ItemTile(
                    item: model.items[index],
                  ),
                ),
                trailing: CircleAvatar(
                  //TODO: Insert current user avatar.
                  // child: Text("MP"),
                  child: Icon(Icons.face),
                ),
                drawer: _buildDrawer(),
              )
            //* if no model, show loading
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                ),
              ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
        elevation: 20,
        child: Column(children: <Widget>[
          DrawerHeader(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Text('Welcome to Renty~'),
                    Icon(Icons.face),
                    Text('You are not verified yet.')
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              )),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Transaction History'),
                leading: Icon(Icons.history),
                onTap: () {},
              ),
              ListTile(
                title: Text('Help'),
                leading: Icon(Icons.help),
                onTap: () {},
              ),
              ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {})
            ],
          )),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
              padding: EdgeInsets.all(10),
              height: 100,
              child: Text(
                "V1.0.0",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ]));
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

  void setState(Null Function() param0) {}
}
