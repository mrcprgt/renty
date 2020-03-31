import 'dart:convert';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/constants/tos.dart';
import 'package:renty_crud_version/ui/shared/ui_helpers.dart';
import 'package:renty_crud_version/ui/widgets/step_progress.dart';
import 'package:renty_crud_version/viewmodels/verification_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_picker/flutter_picker.dart';
import "../../constants/AddressData.dart";
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class VerificationView extends StatefulWidget {
  @override
  _VerificationViewState createState() => _VerificationViewState();
}

//Global Variables kek

//FormBuilder Key
final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

//Controller for Pageview
final PageController _pageController = new PageController(keepPage: true);
int _curPage = 1;

//Step Progress Variables
final _stepsText = ["Birthdate", "Address", "Valid ID", "Legality"];
final _stepCircleRadius = 10.0;
final _stepProgressViewHeight = 150.0;
Color _activeColor = Colors.pink;
Color _inactiveColor = Colors.blue;
TextStyle _headerStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
TextStyle _stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
Size _safeAreaSize;

class _VerificationViewState extends State<VerificationView> {
  bool checked = false;

  File _image;

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerificationViewModel>.withConsumer(
      viewModel: VerificationViewModel(),
      builder: (context, model, child) {
        var mediaQD = MediaQuery.of(context);
        _safeAreaSize = mediaQD.size;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Account Verification"),
            ),
            body: Column(
              children: <Widget>[
                Container(height: 100.0, child: _getStepProgress()),
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
                        BirthDateForm(),
                        AddressForm(),
                        _buildValidID(),
                        _buildTOS(model),
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
        top: 24.0,
        left: 24.0,
        right: 24.0,
      ),
    );
  }

  //TODO: make 2 image pickers and upload them to firestore
  Widget _buildValidID() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Valid ID", style: TextStyle(fontSize: 24)),
                  Icon(Icons.contact_mail, size: 25)
                ],
              ),
              collapsed: Text(
                "Please provide a front and back picture of your Valid ID.",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Please provide a front and back picture of your Valid ID. Example of Valid ID's : "),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("· Driver's License"),
                      Text("· Passport"),
                      Text("· PRC"),
                      Text("· SSS/GSIS ID"),
                      Text("· BIR ID"),
                      Text("· Philhealth Card"),
                      Text("· Company ID"),
                      Text("· NBI Clearance"),
                      Text("· School ID"),
                      Text("· Postal ID"),
                      Text("· Senior Citizen ID"),
                      Text(
                          "· Marriage Certificate with Barangay/Police Clearance"),
                      Text("· OFW ID"),
                      Text("· Seaman\s Book, NCWDP, DSWD ID"),
                    ],
                  ),
                ],
              ),

              // PRC, SSS/GSIS ID, BIR ID, Philhealth Card, Company ID, NBI Clearance, School ID, Postal ID, Senior Citizen ID, Marriage Certificate with Barangay/Police Clearance, OFW ID, Seaman's Book, NCWDP, DSWD ID",
            ),
            Container(
              width: 300,
              child: RaisedButton(
                onPressed: () => getImage(ImgSource.Camera),
                color: Colors.deepPurple,
                child: Text(
                  "From Camera".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 300,
              child: RaisedButton(
                onPressed: () => getImage(ImgSource.Both),
                color: Colors.red,
                child: Text(
                  "Both".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            _image != null ? Image.file(_image) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTOS(VerificationViewModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Text(
              TOS,
              textAlign: TextAlign.justify,
            ),
            FormBuilderCheckbox(
              attribute: "checked",
              label: Text(
                "I agree to the terms and conditions.",
                style: TextStyle(fontSize: 16),
              ),
              onChanged: (val) {
                model.submitAccountVerification(
                    _fbKey.currentState.fields["gender"].currentState.value,
                    _fbKey.currentState.fields["birth_date"].currentState.value,
                    _fbKey.currentState.fields["contact_number"].currentState
                        .value,
                    _fbKey
                        .currentState.fields["address_name"].currentState.value,
                    _fbKey
                        .currentState.fields["floor_unitno"].currentState.value,
                    _fbKey.currentState.fields["city_municipality"].currentState
                        .value,
                    _fbKey.currentState.fields["barangay_street"].currentState
                        .value,
                    _fbKey.currentState.fields["additional_notes"].currentState
                        .value);
              },
              decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          ],
        ),
      ),
    );
  }
}

class BirthDateForm extends StatefulWidget {
  @override
  _BirthDateFormState createState() => _BirthDateFormState();
}

class _BirthDateFormState extends State<BirthDateForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+639##-###-####", filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
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
              attribute: "gender",
              items: ['Male', 'Female', 'Other']
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text("$gender")))
                  .toList(),
              hint: Text("Gender"),
              onChanged: (val) => _fbKey.currentState.save(),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.pink,
                  //labelText: "Occupation",
                  helperText: "Select your gender"),
              validators: [FormBuilderValidators.required()],
            ),
            FormBuilderDateTimePicker(
              attribute: "birth_date",
              inputType: InputType.date,
              format: DateFormat.yMMMMd(),
              onEditingComplete: () => _fbKey.currentState.save(),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                  fillColor: Colors.pink,
                  labelText: "Birthdate",
                  hintText: "--/--/----",
                  helperText: "Enter your birthdate here"),
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            verticalSpaceSmall,
            FormBuilderTextField(
              attribute: "contact_number",
              initialValue: "+639",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [maskTextInputFormatter],
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  fillColor: Colors.pink,
                  labelText: "Contact Number",
                  helperText: "Enter your contact number here"),
              validators: [FormBuilderValidators.required()],
              onEditingComplete: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  setState(() {
                    _pageController.jumpToPage(_curPage);
                    FocusScope.of(context).unfocus();
                    //FocusScope.of(context).nextFocus();
                  });
                }
              },
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String cityValue, streetValue = "";
  TextEditingController cityController,
      streetController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cityController = new TextEditingController(text: ' ');
    streetController = new TextEditingController(text: ' ');
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

          // prrint(cityValue + "" + streetValue);
          print(cityController);
          cityController.value = TextEditingValue(
            text: cityValue,
            selection: TextSelection.fromPosition(
              TextPosition(offset: cityValue.length),
            ),
          );
          streetController.value = TextEditingValue(
            text: streetValue,
            selection: TextSelection.fromPosition(
              TextPosition(offset: streetValue.length),
            ),
          );
        }).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
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
              textInputAction: TextInputAction.next,
              autofocus: true,
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
              controller: cityController,
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
              controller: streetController,
              focusNode: new AlwaysDisabledFocusNode(),
              attribute: "barangay_street",
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                fillColor: Colors.pink,
                labelText: "Barangay/Street",
              ),
            ),
            FormBuilderTextField(
              attribute: "additional_notes",
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.border_color),
                  fillColor: Colors.pink,
                  labelText: "Additional Notes",
                  helperText:
                      "Put some additional notes regarding your address here."),
            )
          ],
        ),
      ),
    );
  }
}
