import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/viewmodels/item_lend_view_model.dart';
import 'package:renty_crud_version/ui/widgets/lending_form.dart';

class ItemLendView extends StatelessWidget {
  const ItemLendView({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemLendViewModel>.withConsumer(
        viewModel: ItemLendViewModel(),
        //onModelReady: (model) => model.listenToItemListings(),
        builder: (context, model, child) => SafeArea(
                child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pinkAccent,
                title: Text('Lend your Item'),
                centerTitle: true,
                //toolbarOpacity: 2.0,
              ),
              body: LendingForm(),
            )));
  }
}
