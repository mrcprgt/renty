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
          extendBodyBehindAppBar: true,
          appBar: new AppBar(
            automaticallyImplyLeading: true,
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
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                _buildImageGallery(receivedItem),
                _buildProductCard(receivedItem),
                _buildDescriptionPanel(receivedItem),
                //_buildReviewsPanel(receivedItem),
              ]),
            ),
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, model, receivedItem),
        ),
      ),
    );
  }

  Widget _buildProductCard(Item item) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(5),
            decoration: new BoxDecoration(
              border: new BorderDirectional(
                  start: new BorderSide(color: Colors.pink, width: 5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(item.itemName,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
              ],
            )),
        Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
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
                  DataCell(
                      Text("₱ " + item.rentingDetails['perHour'].toString())),
                  DataCell(
                      Text("₱ " + item.rentingDetails['perDay'].toString())),
                  DataCell(
                      Text("₱ " + item.rentingDetails['perWeek'].toString())),
                ]),
              ],
            ),
          ]),
        ),
      ],
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
            height: 250.0,
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

  Widget _buildImages(Item item) {
    final imageList = item.itemImages;
    return Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRect(
          child: PhotoViewGallery.builder(
            itemCount: imageList.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  imageList[index],
                ),
                // // Contained = the smallest possible size to fit one dimension of the screen
                // minScale: PhotoViewComputedScale.contained * 0.8,
                // // Covered = the smallest possible size to fit the whole screen
                // maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            // Set the background color to the "classic white"
            backgroundDecoration: BoxDecoration(
              color: Colors.white,
            ),
            loadingChild: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery(Item item) {
    final imageList = item.itemImages;
    return Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                imageList[index],
              ),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              //heroAttributes: HeroAttributes(tag: imageList[index].id),
            );
          },
          itemCount: imageList.length,
          loadingChild: Center(
            child: CircularProgressIndicator(),
          ),
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
