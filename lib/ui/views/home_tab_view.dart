import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renty_crud_version/ui/views/accounts_view.dart';
import 'package:renty_crud_version/ui/views/home_view.dart';

class HomeTabView extends StatefulWidget {
  @override
  _HomeTabViewState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> pages = [
    HomeView(),
    AccountsView(),
    AccountsView(),
    AccountsView()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => SystemNavigator.pop(),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: pages,
            ),
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                  title: Text('Home'),
                  textAlign: TextAlign.center,
                  icon: Icon(Icons.home),
                  activeColor: Colors.pink,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text('My Items'),
                  textAlign: TextAlign.center,
                  icon: Icon(Icons.storage),
                  activeColor: Colors.pink,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text('Transactions'),
                  textAlign: TextAlign.center,
                  icon: Icon(Icons.history),
                  activeColor: Colors.pink,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text('Account'),
                  icon: Icon(Icons.person),
                  textAlign: TextAlign.center,
                  activeColor: Colors.pink,
                  inactiveColor: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
