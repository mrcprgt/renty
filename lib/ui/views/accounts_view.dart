import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/viewmodels/accounts_view_model.dart';

class AccountsView extends StatefulWidget {
  @override
  _AccountsViewState createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AccountsViewModel>.withConsumer(
      viewModel: AccountsViewModel(),
      builder: (context, model, child) => SafeArea(
        child: SafeArea(
          child: Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomScrollView(slivers: <Widget>[
              // SliverPersistentHeader(delegate: ,)
              _buildHeader(context, model)
            ]),
          )),
        ),
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, AccountsViewModel model) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: false,
      floating: true,
      expandedHeight: 300,
      flexibleSpace: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => model.goToVerification(),
            child: SizedBox(
              height: 75,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.red,
                child: Text(
                    "YOUR ACCOUNT IS NOT YET VERIFIED! TAP HERE TO VERIFY NOW!"),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(model.getUserDetails()[0]),
                  Text(model.getUserDetails()[1]),
                ],
              ),
              Column(
                children: <Widget>[
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/images/logo.png"),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
