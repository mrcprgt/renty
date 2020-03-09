import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/viewmodels/item_details_view_model.dart';
import 'package:renty_crud_version/viewmodels/item_transaction_view_model.dart';

class ItemTransactionView extends StatefulWidget {
  ItemTransactionView({
    Key key,
    this.receivedArguments,
  }) : super(key: key);
  final TransactionArguments receivedArguments;

  @override
  _ItemTransactionViewState createState() => _ItemTransactionViewState();
}

class _ItemTransactionViewState extends State<ItemTransactionView> {
  // , startDate, endDate, startTime, endTime;
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemTransactionViewModel>.withConsumer(
      viewModel: ItemTransactionViewModel(),
      builder: (context, model, child) => SafeArea(
          child: Scaffold(
        body: Text(widget.receivedArguments.rentChosen.toString()),
      )),
    );
  }

  //EOF
}
