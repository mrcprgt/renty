import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/shared/shared_styles.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
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
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(slivers: <Widget>[
              _buildHeader(context, model),
              _myListView(context)
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
      // backgroundColor: Colors.pinkAccent,
      pinned: true,
      floating: false,
      expandedHeight: MediaQuery.of(context).size.height / 2 - 40,
      flexibleSpace: Column(
        children: <Widget>[
          !model.displayBanner()
              ? _buildVerificationBanner(model)
              : Container(),
          _buildAccountHeaders(model),
        ],
      ),
    );
  }

  Row _buildAccountHeaders(AccountsViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "My Account",
              style: TextStyle(fontSize: 36),
            ),
            verticalSpaceSmall,
            Text(model.getUserDetails()[0]),
            Text(model.getUserDetails()[1]),
            model.getUserDetails()[2]
                ? Text("Account Status: Verified")
                : Text("Account Status: Unverified")
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
        ),
      ],
    );
  }

  Widget _myListView(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          Card(
              child: Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.arrow_upward),
                        title: Text('Update Account Details'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      )))),
          Card(
            child: Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(Icons.storage),
                      title: Text('My Items'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ))),
          ),
          Card(
            child: Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text('Frequently Asked Questions'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ))),
          ),
          Card(
            child: Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ))),
          )
        ],
      ),
    );
  }
}

GestureDetector _buildVerificationBanner(AccountsViewModel model) {
  return GestureDetector(
    onTap: () => model.goToVerification(),
    child: SizedBox(
      height: 75,
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.red,
        child:
            Text("YOUR ACCOUNT IS NOT YET VERIFIED! TAP HERE TO VERIFY NOW!"),
      ),
    ),
  );
}
