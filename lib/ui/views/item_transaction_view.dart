import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:renty_crud_version/viewmodels/item_transaction_view_model.dart';

class ItemTransactionView extends StatelessWidget {
  const ItemTransactionView(
      {Key key, this.receivedItem, this.photo, this.heroAttributes})
      : super(key: key);
  final Item receivedItem;
  final PhotoViewHeroAttributes heroAttributes;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemTransactionViewModel>.withConsumer(
        viewModel: ItemTransactionViewModel(),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                  appBar: new AppBar(title: Text('Renting')),
                  body: Padding(
                    padding: EdgeInsets.all(16),
                    child: _buildBody(receivedItem),
                  )),
            ));
  }

  Widget _buildBody(Item item) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Text(
          item.itemName,
          style: new TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        _buildImages(item),
        _buildExpansionTile(item),
        _buildProcedures(item),
      ],
    ));
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

  Widget _buildExpansionTile(Item item) {
    return ExpansionTile(
      title: Text('Description'),
      children: <Widget>[
        Column(
          children: <Widget>[Text(item.itemDescription)],
        )
      ],
    );
  }

  Widget _buildProcedures(Item item) {
    List<FormBuilderFieldOption> radioOptions;
    if (item.rentingDetails['perHour'] != null) {
      radioOptions.add(FormBuilderFieldOption(value: "Hourly"));
    }
    if (item.rentingDetails['perDay'] != null) {
      radioOptions.add(FormBuilderFieldOption(value: "Daily"));
    }
    if (item.rentingDetails['perWeek'] != null) {
      radioOptions.add(FormBuilderFieldOption(value: "Weekly"));
    }
    return FormBuilderRadio(
        initialValue: "null", attribute: "rent_type", options: radioOptions);
  }
}
