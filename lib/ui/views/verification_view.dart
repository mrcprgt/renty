import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/ui/widgets/step_progress.dart';
import 'package:renty_crud_version/viewmodels/verification_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_picker/flutter_picker.dart';
import "../../constants/AddressData.dart";

class VerificationView extends StatefulWidget {
  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final PageController _pageController = new PageController();
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+639##-###-####", filter: {"#": RegExp(r'[0-9]')});
  String cityValue, streetValue = "";
  TextEditingController cityController,
      streetController = new TextEditingController();

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
                      controller: _pageController,
                      onPageChanged: (i) {
                        setState(() {
                          _curPage = i + 1;
                        });
                      },
                      children: <Widget>[
                        _buildBirtdateForms(),
                        _buildAddress(),
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
  List<DropdownMenuItem> occupations = [
    DropdownMenuItem(child: Text("Student")),
    DropdownMenuItem(child: Text("Unemployed")),
    DropdownMenuItem(child: Text("Employed")),
  ];

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
    return SingleChildScrollView(
      child: Padding(
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
            verticalSpaceSmall,
            FormBuilderDropdown(
              attribute: "occupation",
              items: ['Male', 'Female', 'Other']
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text("$gender")))
                  .toList(),
              hint: Text("Gender"),
              onChanged: (val) => _fbKey.currentState.saveAndValidate(),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.pink,
                  //labelText: "Occupation",
                  helperText: "Select your gender"),
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
            verticalSpaceSmall,
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
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address Details",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            FormBuilderTextField(
              attribute: "address_name",
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                  fillColor: Colors.pink,
                  labelText: "Address Name",
                  helperText: "Enter the address name here"),
            ),
            FormBuilderTextField(
              enabled: false,
              attribute: "floor_unitno",
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                  fillColor: Colors.pink,
                  labelText: "Floor/Unit Number",
                  helperText: "Enter the floor or unit number here"),
            ),
            FormBuilderTextField(
              attribute: "city_municipality",
              keyboardType: TextInputType.text,
              initialValue: cityValue,
              onTap: () => showPickerModal(context, cityValue, streetValue,
                  cityController, streetController),
              focusNode: new AlwaysDisabledFocusNode(),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                fillColor: Colors.pink,
                labelText: "City/Municipality",
              ),
            ),
            FormBuilderTextField(
              onTap: () => showPickerModal(context, cityValue, streetValue,
                  cityController, streetController),
              focusNode: new AlwaysDisabledFocusNode(),
              attribute: "street",
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                fillColor: Colors.pink,
                labelText: "Street",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showPickerModal(
    BuildContext context,
    String cityValue,
    String streetValue,
    TextEditingController cityController,
    TextEditingController streetController) {
  new Picker(
      height: 300,
      adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(PickerData)),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (Picker picker, List value) {
        cityValue = picker.adapter.text
            .replaceAll("[", "")
            .split(",")[0]
            .trim()
            .toString();
        streetValue = picker.adapter.text
            .replaceAll("]", "")
            .split(",")[1]
            .trim()
            .toString();

        print(cityValue + "" + streetValue);
      }).showModal(context);
}
