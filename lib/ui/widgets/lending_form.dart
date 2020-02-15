import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:renty_crud_version/services/permission_service.dart';

class LendingForm extends StatefulWidget {
  @override
  _LendingFormState createState() => _LendingFormState();
}

class _LendingFormState extends State<LendingForm>
    with TickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Asset> images = List<Asset>();
  bool imagesPicked = false;
  int currStep = 0;
  bool hourlyCheckBoxValue = false,
      dailyCheckBoxValue = false,
      weeklyCheckBoxValue = false;
  bool pickUpType = false;
  // static var _focusNode = new FocusNode();

  // @override
  // void initState() {
  //   super.initState();
  //   _focusNode.addListener(() {
  //     setState(() {});
  //     print('Has focus: $_focusNode.hasFocus');
  //   });
  // }

  // // @override
  // // void dispose() {
  // //   _focusNode.dispose();
  // //   super.dispose();
  // // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidate: true,
                child: Stepper(
                  physics: ClampingScrollPhysics(),
                  type: StepperType.vertical,
                  currentStep: this.currStep,
                  steps: _buildStepper(),
                  onStepTapped: (index) {
                    setState(() {
                      currStep = index;
                    });
                  },
                  onStepCancel: () {
                    print("You are clicking the cancel button.");
                  },
                  onStepContinue: () {
                    print("You are clicking the continue button.");
                  },
                ),
              )
            ])));
  }

  List<Step> _buildStepper() {
    List<Step> steps = [
      Step(
          title: Text('Item Information'),
          subtitle: Text('What is your item?'),
          content: Column(
            children: <Widget>[..._buildItemDetails()],
          )),
      Step(
          title: Text('Item Photos'),
          subtitle: Text('What does your item look like?'),
          content: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildProductImagesWidgets(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(Icons.photo_camera),
                          Text("Add Photos")
                        ],
                      ),
                      onPressed: loadAssets,
                    ),
                  ),
                ],
              ),
            ],
          )),
      Step(
          title: Text('Renting Details'),
          subtitle: Text('How much would you charge for your item?'),
          content: Column(
            children: <Widget>[
              ..._buildRentingDetails(),
            ],
          )),
      Step(
          title: Text('Item Acquisition'),
          subtitle: Text('How will Renty acquire your item?'),
          content: Column(
            children: <Widget>[..._buildPickupDetails()],
          ))
    ];

    return steps;
  }

  FormBuilderCheckbox buildFormBuilderCheckbox() {
    return FormBuilderCheckbox(
      attribute: 'accept_terms',
      label: Text("I have read and agree to the terms and conditions"),
      validators: [
        FormBuilderValidators.requiredTrue(
          errorText: "You must accept terms and conditions to continue",
        ),
      ],
    );
  }

  List<Widget> _buildItemDetails() {
    return <Widget>[
      SizedBox(
        height: 20,
      ),
      FormBuilderTextField(
        validators: [
          FormBuilderValidators.required(
              errorText: "Please fill out this field."),
        ],
        attribute: "item_name",
        maxLength: 30,
        decoration: new InputDecoration(
          labelText: "Item Name",
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      FormBuilderTextField(
        attribute: "text",
        maxLines: 5,
        maxLength: 150,
        maxLengthEnforced: true,
        validators: [
          FormBuilderValidators.required(
              errorText: "Please fill out this field."),
          FormBuilderValidators.min(20,
              errorText: "Please provide a longer description.")
        ],
        decoration: new InputDecoration(
          labelText: "Item Description",
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  List<Widget> _buildRentingDetails() {
    return <Widget>[
      Column(
        children: <Widget>[
          CheckboxListTile(
            value: hourlyCheckBoxValue,
            onChanged: (val) {
              if (hourlyCheckBoxValue == false) {
                setState(() {
                  hourlyCheckBoxValue = true;
                });
              } else if (hourlyCheckBoxValue == true) {
                setState(() {
                  hourlyCheckBoxValue = false;
                });
              }
            },
            subtitle: hourlyCheckBoxValue
                ? FormBuilderTextField(
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill out this field."),
                    ],
                    keyboardType: TextInputType.numberWithOptions(),
                    attribute: "hourly_rent_rate",
                    maxLength: 4,
                    decoration: new InputDecoration(
                      labelText: "Hourly Rent Rate",
                      border: OutlineInputBorder(),
                    ),
                  )
                : null,
            title: new Text(
              'Hourly?',
              style: TextStyle(fontSize: 14.0),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
          ),
          CheckboxListTile(
            value: dailyCheckBoxValue,
            onChanged: (val) {
              if (dailyCheckBoxValue == false) {
                setState(() {
                  dailyCheckBoxValue = true;
                });
              } else if (dailyCheckBoxValue == true) {
                setState(() {
                  dailyCheckBoxValue = false;
                });
              }
            },
            subtitle: dailyCheckBoxValue
                ? FormBuilderTextField(
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill out this field."),
                    ],
                    attribute: "hourly_rent_rate",
                    maxLength: 4,
                    decoration: new InputDecoration(
                      labelText: "Daily Rent Rate",
                      border: OutlineInputBorder(),
                    ),
                  )
                : null,
            title: new Text(
              'Daily?',
              style: TextStyle(fontSize: 14.0),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
          ),
          CheckboxListTile(
            value: weeklyCheckBoxValue,
            onChanged: (val) {
              if (weeklyCheckBoxValue == false) {
                setState(() {
                  weeklyCheckBoxValue = true;
                });
              } else if (weeklyCheckBoxValue == true) {
                setState(() {
                  weeklyCheckBoxValue = false;
                });
              }
            },
            subtitle: weeklyCheckBoxValue
                ? FormBuilderTextField(
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill out this field."),
                    ],
                    attribute: "weekly_rent_rate",
                    maxLength: 4,
                    decoration: new InputDecoration(
                      labelText: "Weekly Rent Rate",
                      border: OutlineInputBorder(),
                    ),
                  )
                : null,
            title: new Text(
              'Weekly?',
              style: TextStyle(fontSize: 14.0),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
          ),
        ],
      )
    ];
  }

  Widget _buildCategoriesChips() {
    return FormBuilderChipsInput(
        attribute: "categories",
        chipBuilder: null,
        suggestionBuilder: null,
        findSuggestions: null);
  }

  List<Widget> _buildPickupDetails() {
    return <Widget>[
      FormBuilderRadio(
        decoration: new InputDecoration(
          labelText: "Item Acquisition",
          border: OutlineInputBorder(),
        ),
        attribute: "acquisition_type",
        options: [
          FormBuilderFieldOption(value: "Drop Off"),
          FormBuilderFieldOption(value: "Pickup via Pandalivery"),
        ],
        onChanged: (value) {
          _fbKey.currentState.save();
          print(_fbKey
              .currentState.fields["acquisition_type"].currentState.value);
          _fbKey.currentState.fields["acquisition_type"].currentState.value ==
                  "Pickup via Pandalivery"
              ? setState(() {
                  pickUpType = true;
                })
              : setState(() {
                  pickUpType = false;
                });
        },
      ),
      pickUpType
          ? FormBuilderDateTimePicker(
              attribute: "date",
              format: DateFormat("yyyy-MM-dd hh:mm"),
              decoration: InputDecoration(labelText: "Appointment Time"),
            )
          : Container()
    ];
  }

  Widget _buildProductImagesWidgets() {
    TabController imagesController =
        TabController(length: images.length, vsync: this);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: new BoxDecoration(
            border: Border.all(color: Colors.black, width: 2)),
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: 3,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  controller: imagesController,
                  children: List.generate(images.length, (index) {
                    Asset asset = images[index];
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: AssetThumb(
                        asset: asset,
                        width: 200,
                        height: 300,
                      ),
                    );
                  }),
                ),
                Container(
                  alignment: FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    PermissionsService().requestCameraPermission();
    PermissionsService().requestStoragePermission();
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 5,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) print('No error detected.');
      if (images.length != null) {
        imagesPicked = true;
      } else {
        imagesPicked = false;
      }
    });
  }
//EOF
}
