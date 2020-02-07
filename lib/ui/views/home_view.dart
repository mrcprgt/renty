import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    _buildAppBar(context),
                    _buildSliverHeader(),
                    _buildCategoriesBar(),
                    _buildGridView(context, model),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                ),
              ),
        //bottomNavigationBar: _buildBottomNavBar(),
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

  Widget _buildCategoriesBar() {
    return SliverToBoxAdapter(
        child: Container(
      height: 60.0,
      //TODO: CHANGE THIS TO STREAM CATEGORIES
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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
                          'Category',
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5.0,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      title: new TextField(
        //focusNode: _searchFocusNode,
        //style: Theme.of(context).primaryTextTheme.title,
        decoration: InputDecoration(
          // border: OutlineInputBorder(
          //     borderRadius:
          //         BorderRadius.all(Radius.circular(1.0))),
          suffixIcon: Icon(Icons.search),
          hintText: 'What do you want to borrow?',
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, HomeViewModel model) {
    return new SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: model.items.length,
      itemBuilder: ((BuildContext context, index) => GestureDetector(
            //onTap:
            child: ItemTile(
              item: model.items[index],
            ),
          )),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  // new SliverGrid(
  //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //     maxCrossAxisExtent: 400.0,
  //     mainAxisSpacing: 5.0,
  //     crossAxisSpacing: 5.0,
  //     childAspectRatio: 0.6,
  //   ),
  //   delegate: SliverChildBuilderDelegate(
  //       (BuildContext context, index) => GestureDetector(
  //             //onTap:
  //             child: ItemTile(
  //               item: model.items[index],
  //             ),
  //           ),
  //       childCount: model.items.length),
  // )
}
