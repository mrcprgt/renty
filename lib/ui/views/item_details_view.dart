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
          appBar: AppBar(
            backgroundColor: Colors.pinkAccent,
            title: Text('Item Details'),
            centerTitle: true,
            //toolbarOpacity: 2.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                _buildImages(receivedItem),
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
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          padding: EdgeInsets.all(5),
          decoration: new BoxDecoration(
            border: new BorderDirectional(
                start: new BorderSide(color: Colors.pink, width: 5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //ITEM NAME
              Text(item.itemName,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
              DataTable(
                columns: [
                  DataColumn(label: Text('Duration')),
                  DataColumn(label: Text('Price')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Hourly')),
                    DataCell(Text(item.rentingDetails['perHour'].toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Daily')),
                    DataCell(Text(item.rentingDetails['perDay'].toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Weekly')),
                    DataCell(Text(item.rentingDetails['perWeek'].toString())),
                  ]),
                ],
              ),
              // Text(
              //   item.rentingDetails[1].toString() +
              //       ' / ' +
              //       item.rentingDetails['perDay'].toString(),
              //   style: TextStyle(fontWeight: FontWeight.w400),
              // )
            ],
          )),
    );
  }

  Widget _buildDescriptionPanel(Item item) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Description', style: new TextStyle(fontSize: 18)),
          Text(item.itemDescription),
        ],
      ),
    );
  }

  Widget _buildReviewsPanel(Item item) {
    return ExpansionTile(
      title: Text('Reviews'),
      children: <Widget>[
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 50,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  border: new BorderDirectional(
                      start: new BorderSide(color: Colors.pink)),
                ),
                child: Text('Review'),
              );
            },
          ),
        ),
      ],
    );
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
