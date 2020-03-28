import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/viewmodels/verification_view_model.dart';

class VerificationView extends StatefulWidget {
  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerificationViewModel>.withConsumer(
      viewModel: VerificationViewModel(),
      builder: (context, model, child) => SafeArea(
        child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ),
    );
  }
}
