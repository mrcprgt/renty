import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:renty_crud_version/viewmodels/startup_view_model.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
        viewModel: StartUpViewModel(),
        onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 300, height: 100, child: Image.asset('assets/images/logo.png')),
                CircularProgressIndicator(
                    strokeWidth: 3,
                    //TODO: Find hex color of logo
                    valueColor: AlwaysStoppedAnimation(Colors.pink))
              ],
            ))));
  }
}
