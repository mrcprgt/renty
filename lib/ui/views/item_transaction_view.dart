import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/viewmodels/item_details_view_model.dart';
import 'package:renty_crud_version/viewmodels/item_transaction_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

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
  Duration rentingDuration;

  Widget build(BuildContext context) {
    return ViewModelProvider<ItemTransactionViewModel>.withConsumer(
      viewModel: ItemTransactionViewModel(),
      builder: (context, model, child) => SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context, widget.receivedArguments),
            SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  _buildTransactionOverview(context, widget.receivedArguments)
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildAppBar(
      BuildContext context, TransactionArguments transactionArguments) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: false,
      floating: true,
      expandedHeight: 200,
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
          )),
      //title: Text('Checkout'),
      flexibleSpace: _buildProductOverview(context, transactionArguments),
    );
  }

  Widget _buildProductOverview(
      BuildContext context, TransactionArguments transactionArguments) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      transactionArguments.item.itemName.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: transactionArguments.item.itemImages[0],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateRentingDuration(TransactionArguments transactionArguments) {
    switch (transactionArguments.rentChosen) {
      case "Hourly":
        rentingDuration = transactionArguments.endRentDate
            .difference(transactionArguments.startRentDate);
        print(transactionArguments.endRentDate.toString() +
            " - " +
            transactionArguments.startRentDate.toString());
        print(rentingDuration.inHours);
        return rentingDuration.inHours.toInt();
        break;
      case "Daily":
        rentingDuration = transactionArguments.endRentDate
            .difference(transactionArguments.startRentDate);
        return rentingDuration.inDays.toInt();
        break;
    }
  }

  double checkRentChosen(TransactionArguments transactionArguments) {
    double currentRentChosen;
    switch (transactionArguments.rentChosen) {
      case "Hourly":
        currentRentChosen =
            double.parse(transactionArguments.item.rentingDetails["perHour"]);
        break;
      case "Daily":
        currentRentChosen =
            double.parse(transactionArguments.item.rentingDetails["perDay"]);
        break;
      case "Weekly":
        currentRentChosen =
            double.parse(transactionArguments.item.rentingDetails["perWeek"]);
        break;
    }

    return currentRentChosen;
  }

  double calculateServiceFee(TransactionArguments transactionArguments) {
    int rentDuration = _calculateRentingDuration(transactionArguments);
    double serviceFee =
        (rentDuration * checkRentChosen(transactionArguments)) * 0.25;

    // print(serviceFee.runtimeType);
    return serviceFee;
  }

  calculateTotal(TransactionArguments transactionArguments) {
    double serviceFeePayable = calculateServiceFee(transactionArguments);
    // print("Renting Duration: " +
    //     _calculateRentingDuration(transactionArguments).toString() +
    //     " * Rent Chosen: " +
    //     checkRentChosen(transactionArguments).toString() +
    //     " Service Fee Payable:  " +
    //     serviceFeePayable.toString());
    double totalPayable = (_calculateRentingDuration(transactionArguments) *
            checkRentChosen(transactionArguments)) +
        serviceFeePayable;
    // print(totalPayable.toString());
    return totalPayable;
  }

  formatDateForDisplaying(DateTime date) {
    String formattedDate = Jiffy(date).yMMMMEEEEdjm;
    return formattedDate;
  }

  _buildTransactionOverview(
          BuildContext context, TransactionArguments transactionArguments) =>
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "TRANSACTION DETAILS",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  Text(formatDateForDisplaying(
                          transactionArguments.startRentDate) +
                      " to " +
                      formatDateForDisplaying(
                          transactionArguments.endRentDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildRightSideTransactionDetails(),
                  _buildLeftSideTransactionDetails(transactionArguments)
                ],
              ),
              //FlatButton(onPressed: ,)
            ],
          ),
        ),
      );

  Column _buildLeftSideTransactionDetails(
      TransactionArguments transactionArguments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          transactionArguments.rentChosen == "Daily"
              ? transactionArguments.item.rentingDetails["perDay"].toString() +
                  ".00"
              : transactionArguments.rentChosen == "Hourly"
                  ? transactionArguments.item.rentingDetails["perHour"]
                          .toString() +
                      ".00"
                  : transactionArguments.item.rentingDetails["perWeek"]
                          .toString() +
                      ".00",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _calculateRentingDuration(transactionArguments).toString() +
              "${transactionArguments.rentChosen}",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          calculateServiceFee(transactionArguments).toString(),
          style: TextStyle(fontSize: 18),
        ),
        Text(
          calculateTotal(transactionArguments).toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Column _buildRightSideTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Rent Rate",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "Rent Duration",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "Service Fee",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "TOTAL",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  //EOF
}
