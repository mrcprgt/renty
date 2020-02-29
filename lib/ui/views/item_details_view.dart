import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/viewmodels/item_details_view_model.dart';
import 'package:photo_view/photo_view.dart';

import 'package:photo_view/photo_view_gallery.dart';

class ItemDetailView extends StatelessWidget {
  const ItemDetailView(
      {Key key, this.receivedItem, this.photo, this.heroAttributes})
      : super(key: key);
  final Item receivedItem;
  final PhotoViewHeroAttributes heroAttributes;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemDetailViewModel>.withConsumer(
      viewModel: ItemDetailViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, receivedItem),
              _buildProductCard(receivedItem),
              //_buildDescriptionPanel(receivedItem)
            ],
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, model, receivedItem),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Item item) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //elevation: 5.0,
      //automaticallyImplyLeading: true,
      leading: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Material(
              color: Colors.pink,
              shape: new CircleBorder(),
              child: Icon(Icons.arrow_back)),
        ),
      ),
      pinned: false,
      floating: true,
      expandedHeight: 300,
      flexibleSpace: _buildImageGallery(item),
    );
  }

  Widget _buildProductCard(Item item) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(item.itemName,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24)),
                  ],
                )),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DataTable(
                      headingRowHeight: 25,
                      dataRowHeight: 25,
                      columns: [
                        DataColumn(label: Center(child: Text('Hourly'))),
                        DataColumn(label: Center(child: Text('Daily'))),
                        DataColumn(label: Center(child: Text('Weekly'))),
                      ],
                      rows: [
                        DataRow(cells: [
                          item.rentingDetails['perHour'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perHour'].toString()))
                              : DataCell(Text("- - -")),
                          item.rentingDetails['perDay'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perDay'].toString()))
                              : DataCell(Text("- - -")),
                          item.rentingDetails['perWeek'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perWeek'].toString()))
                              : DataCell(Text("- - -")),
                        ]),
                      ],
                    ),
                  ]),
            ),
            _buildDescriptionPanel(item)
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionPanel(Item item) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Colors.pink,
            // controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "REVIEWS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: 800,
            child: TabBarView(
              //controller: tabController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Text(
                    item.itemDescription,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  "5 STAR VERY SOLID PRODUCT WILL RENT AGAIN",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   alignment: Alignment.topLeft,
    //   padding: EdgeInsets.all(5),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Text('Description', style: new TextStyle(fontSize: 20)),
    //       Text(item.itemDescription),
    //     ],
    //   ),
    // );
  }

  Widget _buildImageGallery(Item item) {
    final imageList = item.itemImages;
    return SizedBox(
      height: 300,
      child: PhotoViewGallery.builder(
        gaplessPlayback: true,
        reverse: true,
        pageController: new PageController(),
        //scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              imageList[index],
            ),
            // minScale: PhotoViewComputedScale.contained * 0.8,
            // maxScale: PhotoViewComputedScale.covered * 1.1,
            initialScale: PhotoViewComputedScale.covered * 0.6,
            //heroAttributes: HeroAttributes(tag: imageList[index].id),
          );
        },
        itemCount: imageList.length,
        loadingChild: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, ItemDetailViewModel model, Item item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.lightBlueAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Wish",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              onPressed: () {
                model.goToTransactionView(item);
              },
              color: Colors.pinkAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.card_travel,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "RENT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
