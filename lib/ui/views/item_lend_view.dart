import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/viewmodels/item_details_view_model.dart';

class ItemDetailView extends StatelessWidget {
  const ItemDetailView({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemDetailViewModel>.withConsumer(
        viewModel: ItemDetailViewModel(),
        //onModelReady: (model) => model.listenToItemListings(),
        builder: (context, model, child) => SafeArea(
                child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pinkAccent,
                title: Text('Item Details'),
                centerTitle: true,
                //toolbarOpacity: 2.0,
              ),
              body: Text('dofgo'),
            )));
  }
}
