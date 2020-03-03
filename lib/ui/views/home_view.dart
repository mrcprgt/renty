import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/widgets/item_listing_tile.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:renty_crud_version/viewmodels/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.listenToItemListings(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () => onWillPop(),
        child: SafeArea(
          child: Scaffold(
            body: model.items != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _buildAppBar(context, model),
                        _buildSliverHeader(),
                        //_buildCategoriesBar(context, model),
                        _buildGridView(context, model),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pink),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.pink,
              child: Icon(Icons.add),
              onPressed: () => model.goToItemLendPage(),
            ),
            bottomNavigationBar: _buildBottomNavBar(context, model),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverToBoxAdapter(
      child: Container(
        child: Text(
          'Good Morning, User',
          textScaleFactor: 2.5,
        ),
      ),
    );
  }

  Widget _buildCategoriesBar(BuildContext context, HomeViewModel model) {
    return SliverToBoxAdapter(
        child: Container(
      height: 60.0,
      //TODO: CHANGE THIS TO STREAM CATEGORIES
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        // itemCount: model.operations.categoriesMap.length,
        //model.categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      // child: SizedBox(
                      //     width: 50, height: 10, child: Icon(Icons.menu)),
                      child: Icon(Icons.menu),
                      onTap: () {},
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'dog',
                          //model.categories[index].categoryName,
                          textScaleFactor: 0.75,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context, HomeViewModel model) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5.0,
      automaticallyImplyLeading: false,
      pinned: false,
      floating: true,
      title: _buildSearchField(context, model),
    );
  }

  Widget _buildSearchField(BuildContext context, HomeViewModel model) {
    //TODO: make suggestions go to item detail
    return new TypeAheadField(
      hideSuggestionsOnKeyboardHide: true,
      noItemsFoundBuilder: (context) =>
          Text('No item found. Try putting it on the wish list!'),
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          style: TextStyle(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          )),
      suggestionsCallback: (pattern) async {
        return await model.searchOptions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          //leading: Icon(Icons.shopping_cart),
          title: Text(suggestion),
          //subtitle: Text('\$${suggestion['price']}'),
        );
      },
      onSuggestionSelected: (suggestion) {
        model.goToItemDetailPage(model.items[suggestion]);
      },
    );
  }

  Widget _buildGridView(BuildContext context, HomeViewModel model) {
    return new SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.75, crossAxisCount: 2),

      ///Lazy building of list
      delegate: SliverChildBuilderDelegate(
        ((BuildContext context, index) => GestureDetector(
              onTap: () => model.goToItemDetailPage(model.items[index]),
              child: ItemTile(
                item: model.items[index],
                onPressed: () => model.goToItemDetailPage(model.items[index]),
              ),
            )),

        /// Set childCount to limit no.of items
        childCount: model.items.length,
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, HomeViewModel model) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.person),
          title: new Text('Profile'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), title: Text('Settings'))
      ],
    );
  }

  //TODO : Double tap back to exit.
  Future<bool> onWillPop() {
    DateTime currentBackPressTime;
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    return Future.value(true);
  }

//EOF
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
