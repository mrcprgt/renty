import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:renty_crud_version/viewmodels/item_transaction_view_model.dart';
import 'package:intl/intl.dart';

class ItemTransactionView extends StatefulWidget {
  ItemTransactionView(
      {Key key, this.receivedItem, this.photo, this.heroAttributes})
      : super(key: key);
  final Item receivedItem;
  final PhotoViewHeroAttributes heroAttributes;
  final String photo;

  @override
  _ItemTransactionViewState createState() => _ItemTransactionViewState();
}

class _ItemTransactionViewState extends State<ItemTransactionView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool hourlyRadio = false, dailyRadio = false, weeklyRadio = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ItemTransactionViewModel>.withConsumer(
        viewModel: ItemTransactionViewModel(),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                  body: CustomScrollView(
                slivers: <Widget>[
                  _buildSliverAppBar(widget.receivedItem, context),
                  _buildBody(widget.receivedItem)
                ],
              )),
            ));
  }

  Widget _buildSliverAppBar(Item item, BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //elevation: 5.0,
      //automaticallyImplyLeading: true,
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
        ),
      ),
      title: Text(item.itemName),
      pinned: false,
      floating: false,
      expandedHeight: 175,
      flexibleSpace: _buildImageGallery(item),
    );
  }

  Widget _buildBody(Item item) {
    return SliverFillRemaining(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _fbKey,
        child: Column(
          children: <Widget>[
            Text(
              item.itemName,
              style: new TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            //_buildImages(item),
            _buildExpansionTile(item),
            _buildProcedures(item),
            SizedBox(
              height: 20,
            ),
            _buildChoices(item),
          ],
        ),
      ),
    ));
  }

  Widget _buildImageGallery(Item item) {
    final imageList = item.itemImages;
    return SizedBox(
      height: 300,
      child: PhotoViewGallery.builder(
        gaplessPlayback: true,
        reverse: true,
        pageController: new PageController(),
        //scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              imageList[index],
            ),
            // minScale: PhotoViewComputedScale.contained * 0.8,
            // maxScale: PhotoViewComputedScale.covered * 1.1,
            initialScale: PhotoViewComputedScale.covered,
            //heroAttributes: HeroAttributes(tag: imageList[index].id),
          );
        },
        itemCount: imageList.length,
        loadingChild: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(Item item) {
    return ExpansionTile(
      title: Text('Description'),
      children: <Widget>[
        Column(
          children: <Widget>[Text(item.itemDescription)],
        )
      ],
    );
  }

  Widget _buildProcedures(Item item) {
    List<FormBuilderFieldOption> radioOptions = [];
    if (item.rentingDetails['perHour'] != null) {
      radioOptions.add(FormBuilderFieldOption(
        value: "Hourly",
      ));
    }
    if (item.rentingDetails['perDay'] != null) {
      radioOptions.add(FormBuilderFieldOption(value: "Daily"));
    }
    if (item.rentingDetails['perWeek'] != null) {
      radioOptions.add(FormBuilderFieldOption(value: "Weekly"));
    }
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.pink)),
          ),
          child: Text(
            'Transaction Details',
            style: TextStyle(fontSize: 24),
          ),
        ),
        FormBuilderRadio(
            initialValue: "null",
            attribute: "rent_type",
            options: radioOptions,
            activeColor: Colors.pink,
            onChanged: (val) {
              //_fbKey.currentState.fields['rent_type'].currentState.validate();
              if (_fbKey.currentState.fields["rent_type"].currentState.value ==
                  "Hourly") {
                setState(() {
                  hourlyRadio = !hourlyRadio;
                  dailyRadio = false;
                  weeklyRadio = false;
                });
              }
              if (_fbKey.currentState.fields["rent_type"].currentState.value ==
                  "Daily") {
                setState(() {
                  dailyRadio = !dailyRadio;
                  hourlyRadio = false;
                  weeklyRadio = false;
                });
              }
              if (_fbKey.currentState.fields["rent_type"].currentState.value ==
                  "Weekly") {
                setState(() {
                  weeklyRadio = !weeklyRadio;
                  dailyRadio = false;
                  hourlyRadio = false;
                });
              }
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none))),
      ],
    );
  }

  Widget _buildChoices(Item item) {
    DateTime currentDay = DateTime.now();
    DateTime maxDate =
        new DateTime(currentDay.year, currentDay.month, currentDay.day + 5);
    DateTime maxWeek =
        new DateTime(currentDay.year, currentDay.month, currentDay.day + 14);
    return Column(
      children: <Widget>[
        hourlyRadio
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(4)),
                child: FormBuilderTextField(
                  attribute: "hours_rented",
                  decoration: InputDecoration(
                      hintText: "How many hours will you borrow it?",
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              )
            : Container(),
        dailyRadio
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(4)),
                child: FormBuilderDateRangePicker(
                    attribute: "range_of_days",
                    firstDate: currentDay,
                    lastDate: maxDate,
                    format: DateFormat(
                      "yyyy-MM-dd",
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "How many days will you borrow it?")),
              )
            : Container(),
        weeklyRadio
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(4)),
                child: FormBuilderDateRangePicker(
                  attribute: "range_of_week",
                  firstDate: currentDay,
                  lastDate: maxWeek,
                  format: DateFormat(
                    "yyyy-MM-dd",
                  ),
                  decoration: InputDecoration(
                      hintText: "How many weeks will you borrow it?"),
                ),
              )
            : Container(),
      ],
    );
  }
}
