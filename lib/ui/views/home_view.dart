import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/widgets/creation_aware_list_item.dart';
import 'package:renty_crud_version/ui/widgets/item_listing_tile.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:renty_crud_version/viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.listenToItemListings(),
      builder: (context, model, child) {
        super.build(context);
        return SafeArea(
          child: Scaffold(
            body: model.items != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _buildAppBar(context, model),
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
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, HomeViewModel model) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5.0,
      automaticallyImplyLeading: false,
      pinned: false,
      floating: true,
      flexibleSpace: _buildSearchField(context, model),
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
            border: OutlineInputBorder(borderSide: BorderSide.none),
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
        ((BuildContext context, index) => CreationAwareListItem(
              itemCreated: () {
                // when the item is created we request more data when it's the 20th index
                if (index % 20 == 0) model.requestMoreData();
              },
              child: GestureDetector(
                onTap: () => model.goToItemDetailPage(model.items[index]),
                child: ItemTile(
                  item: model.items[index],
                  onPressed: () => model.goToItemDetailPage(model.items[index]),
                ),
              ),
            )),

        /// Set childCount to limit no.of items
        childCount: model.items.length,
      ),
    );
  }
}
