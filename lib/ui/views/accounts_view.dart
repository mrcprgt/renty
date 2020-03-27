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
              backgroundColor: Colors.white54,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.pink[200],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                          child: Image(
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                        Text(model.getUserDetails()[0]),
                        Text(model.getUserDetails()[1]),
                        Text('Account Address'),
                        Text('Account Contact Number'),
                        RaisedButton(
                          child: Text("Logout"),
                          onPressed: () => model.logOut(),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
