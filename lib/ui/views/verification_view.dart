import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/widgets/step_progress.dart';
import 'package:renty_crud_version/viewmodels/verification_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class VerificationView extends StatefulWidget {
  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+639##-###-####", filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerificationViewModel>.withConsumer(
      viewModel: VerificationViewModel(),
      builder: (context, model, child) {
        var mediaQD = MediaQuery.of(context);
        _safeAreaSize = mediaQD.size;
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Container(height: 150.0, child: _getStepProgress()),
                Expanded(
                  child: FormBuilder(
                    key: _fbKey,
                    child: PageView(
                      onPageChanged: (i) {
                        setState(() {
                          _curPage = i + 1;
                        });
                      },
                      children: <Widget>[
                        _buildBirtdateForms(),
                        _buildBirtdateForms(),
                        _buildBirtdateForms(),
                        _buildBirtdateForms(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Step Progress Variables
  final _stepsText = ["Birthdate", "Address", "Valid ID", "Legality"];
  final _stepCircleRadius = 10.0;
  final _stepProgressViewHeight = 150.0;
  Color _activeColor = Colors.pink;
  Color _inactiveColor = Colors.blue;
  TextStyle _headerStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle _stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
  Size _safeAreaSize;
  int _curPage = 1;

  StepProgressView _getStepProgress() {
    return StepProgressView(
      _stepsText,
      _curPage,
      _stepProgressViewHeight,
      _safeAreaSize.width,
      _stepCircleRadius,
      _activeColor,
      _inactiveColor,
      _headerStyle,
      _stepStyle,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(
        top: 48.0,
        left: 24.0,
        right: 24.0,
      ),
    );
  }

  Widget _buildBirtdateForms() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "We want to know you more!",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          FormBuilderDateTimePicker(
            attribute: "birth_date",
            inputType: InputType.date,
            format: DateFormat.yMMMMd(),
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.cake),
                fillColor: Colors.pink,
                labelText: "Birthdate",
                hintText: "--/--/----",
                helperText: "Enter your birthdate here"),
          ),
          FormBuilderTextField(
            attribute: "contact_number",
            initialValue: "+639",
            keyboardType: TextInputType.number,
            inputFormatters: [maskTextInputFormatter],
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                fillColor: Colors.pink,
                labelText: "Contact Number",
                helperText: "Enter your contact number here"),
          )
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "We want to know you more!",
                style: TextStyle(fontSize: 24),
              ),
            ],
          )
        ]));
  }
}
