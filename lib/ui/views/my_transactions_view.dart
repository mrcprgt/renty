import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/viewmodels/my_transactions_view_model.dart';

class MyTransactionsView extends StatefulWidget {
  @override
  _MyTransactionsViewState createState() => _MyTransactionsViewState();
}

class _MyTransactionsViewState extends State<MyTransactionsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MyTransactionsViewModel>.withConsumer(
        onModelReady: (model) => model.listenToItemListings(),
        viewModel: MyTransactionsViewModel(),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: model.rentals != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "My Transactions",
                                style: TextStyle(fontSize: 24),
                              ),
                              _buildListView(context, model)
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.pink),
                              ),
                              verticalSpaceMedium,
                              Text("Getting things ready...")
                            ],
                          ),
                        ),
                      ),
              ),
            ));
  }

  Widget _buildListView(BuildContext context, MyTransactionsViewModel model) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: model.rentals.length,
          itemBuilder: (context, index) {
            return Card(
                child: Material(
                    color: Colors.white,
                    child: InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: CachedNetworkImage(
                                imageUrl: model
                                    .getItemImgUrl(model.rentals[index].itemID)
                                    .toString()),
                          ),
                          title: Text(model.rentals[index].itemID),
                          subtitle:
                              Text(model.rentals[index].startDate.toString()),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ))));
          }),
    );
  }
}
