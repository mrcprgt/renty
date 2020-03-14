import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/viewmodels/item_details_view_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:supercharged/supercharged.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView(
      {Key key, this.receivedItem, this.photo, this.heroAttributes})
      : super(key: key);
  final Item receivedItem;
  final PhotoViewHeroAttributes heroAttributes;
  final String photo;

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool hourlyChip = false, dailyChip = false, weeklyChip = false;
  static DateTime currentDay = DateTime.now().add(new Duration(days: 1));
  DateTime maxDate =
      new DateTime(currentDay.year, currentDay.month, currentDay.day + 5);
  DateTime maxWeek =
      new DateTime(currentDay.year, currentDay.month, currentDay.day + 14);

  var startRentDate, endRentDate, rentChosen;
  var rentingDuration;

  @override
  Widget build(BuildContext context) {
    print(currentDay);
    return ViewModelProvider<ItemDetailViewModel>.withConsumer(
      viewModel: ItemDetailViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, widget.receivedItem),
              _buildProductCard(widget.receivedItem, context),
              //_buildDescriptionPanel(receivedItem)
            ],
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, model, widget.receivedItem),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Item item) {
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
      pinned: false,
      floating: true,
      expandedHeight: 300,
      flexibleSpace: _buildImageGallery(item),
    );
  }

  Widget _buildProductCard(Item item, BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(item.itemName,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24)),
                  ],
                )),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DataTable(
                      headingRowHeight: 25,
                      dataRowHeight: 25,
                      columns: [
                        DataColumn(label: Center(child: Text('Hourly'))),
                        DataColumn(label: Center(child: Text('Daily'))),
                        DataColumn(label: Center(child: Text('Weekly'))),
                      ],
                      rows: [
                        DataRow(cells: [
                          item.rentingDetails['perHour'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perHour'].toString()))
                              : DataCell(Text("- - -")),
                          item.rentingDetails['perDay'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perDay'].toString()))
                              : DataCell(Text("- - -")),
                          item.rentingDetails['perWeek'] != null
                              ? DataCell(Text("₱ " +
                                  item.rentingDetails['perWeek'].toString()))
                              : DataCell(Text("- - -")),
                        ]),
                      ],
                    ),
                  ]),
            ),
            _buildDescriptionPanel(item, context)
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionPanel(Item item, BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Colors.pink,
            // controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "REVIEWS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            constraints: (BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width)),
            child: TabBarView(
              //controller: tabController,
              children: <Widget>[
                SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Text(
                    item.itemDescription,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Text(
                      "5 STAR VERY SOLID PRODUCT WILL RENT AGAIN",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildBottomNavigationBar(
      BuildContext context, ItemDetailViewModel model, Item item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.lightBlueAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Add to List",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              onPressed: () {
                showRentingDetails(item, context, model);
                // model.goToTransactionView(item);
              },
              color: Colors.pinkAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.card_travel,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "RENT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showRentingDetails(
          Item item, BuildContext context, ItemDetailViewModel model) =>
      showModalBottomSheet(
          isScrollControlled: true,
          elevation: 1,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, StateSetter setState) {
                return Container(
                  //alignment: Alignment(0.0, 0.0),
                  height: 500,
                  // width: MediaQuery.of(context).size.width,
                  padding: new EdgeInsets.all(32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Rent Rates Available',
                          style: TextStyle(fontSize: 24),
                        ),
                        FormBuilder(
                          key: _fbKey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              buildChoiceChips(item, setState),
                              Divider(
                                color: Colors.pink,
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildRentingInput(context),
                              goToCheckOut(context, item, model)
                            ],
                          ),
                        )
                      ]),
                );
              },
            );
          });

  Column buildRentingInput(BuildContext context) {
    return Column(
      children: <Widget>[
        hourlyChip ? buildHourlyPicker() : Container(),
        dailyChip ? _buildDailyPicker() : Container(),
        weeklyChip ? _buildWeekPicker() : Container(),
      ],
    );
  }

  Container buildHourlyPicker() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: FormBuilderDateTimePicker(
            attribute: "start_time",
            inputType: InputType.both,
            initialTime: TimeOfDay.now(),
            initialDate: currentDay,
            firstDate: currentDay,
            onChanged: (val) {
              startRentDate = val;
            },
            decoration: InputDecoration(
                labelText: "Start Time", border: OutlineInputBorder()),
          )),
          SizedBox(
            height: 10,
          ),
          Container(
              // width: MediaQuery.of(context).size.width / 2 - 32,
              child: FormBuilderDateTimePicker(
            format: DateFormat("jm"),
            attribute: "end_time",
            onChanged: (val) {
              endRentDate = new DateTime(
                startRentDate.year,
                startRentDate.month,
                startRentDate.day,
                val.hour,
                val.minute,
              );
            },
            inputType: InputType.time,
            decoration: InputDecoration(
                labelText: "End Time", border: OutlineInputBorder()),
          )),
        ],
      ),
    );
  }

  Column _buildWeekPicker() {
    return Column(
      children: <Widget>[
        FormBuilderDateRangePicker(
          attribute: "range_of_week",
          firstDate: DateTime.now(),
          lastDate: maxWeek,
          format: DateFormat(
            "yyyy-MM-dd",
          ),
          onChanged: (picked) {
            startRentDate = _fbKey
                .currentState.fields["range_of_week"].currentState.value[0];
            endRentDate = _fbKey
                .currentState.fields["range_of_week"].currentState.value[1];
          },
          decoration: InputDecoration(
              labelText: "Renting Duration", border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
        FormBuilderDateTimePicker(
          attribute: "time",
          inputType: InputType.time,
          initialTime: TimeOfDay.now(),
          onChanged: (val) {
            startRentDate = new DateTime(startRentDate.year,
                startRentDate.month, startRentDate.day, val.hour, val.minute);
            endRentDate = new DateTime(endRentDate.year, endRentDate.month,
                endRentDate.day, val.hour, val.minute);
          },
          decoration: InputDecoration(
              labelText: "Time Needed", border: OutlineInputBorder()),
        )
      ],
    );
  }

  Column _buildDailyPicker() {
    return Column(
      children: <Widget>[
        FormBuilderDateRangePicker(
          attribute: "range_of_days",
          firstDate: DateTime.now(),
          lastDate: maxDate,
          format: DateFormat(
            "MMM d, yyyy",
          ),
          decoration: InputDecoration(
              labelText: "Renting Duration", border: OutlineInputBorder()),
          onChanged: (picked) {
            startRentDate = _fbKey
                .currentState.fields["range_of_days"].currentState.value[0];
            endRentDate = _fbKey
                .currentState.fields["range_of_days"].currentState.value[1];
          },
        ),
        SizedBox(
          height: 10,
        ),
        FormBuilderDateTimePicker(
          attribute: "time",
          inputType: InputType.time,
          format: DateFormat("jm"),
          initialTime: TimeOfDay.now(),
          onChanged: (val) {
            startRentDate = new DateTime(startRentDate.year,
                startRentDate.month, startRentDate.day, val.hour, val.minute);
            endRentDate = new DateTime(endRentDate.year, endRentDate.month,
                endRentDate.day, val.hour, val.minute);
          },
          decoration: InputDecoration(
              labelText: "Time Needed", border: OutlineInputBorder()),
        )
      ],
    );
  }

  Container buildChoiceChips(Item item, StateSetter setState) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          item.rentingDetails['perHour'] != null
              ? ChoiceChip(
                  label: Text(
                    "Php " +
                        item.rentingDetails['perHour'].toString() +
                        " / hour",
                    style: TextStyle(fontSize: 18),
                  ),
                  selected: hourlyChip,
                  onSelected: (bool _hourlyChip) {
                    setState(() {
                      hourlyChip = _hourlyChip;
                      dailyChip = false;
                      weeklyChip = false;
                    });
                  },
                )
              : Container(),
          SizedBox(width: 10),
          item.rentingDetails['perDay'] != null
              ? ChoiceChip(
                  label: Text(
                    "Php " +
                        item.rentingDetails['perDay'].toString() +
                        " / day",
                    style: TextStyle(fontSize: 18),
                  ),
                  selected: dailyChip,
                  onSelected: (bool _dailyChip) {
                    setState(() {
                      dailyChip = _dailyChip;
                      hourlyChip = false;
                      weeklyChip = false;
                    });
                  },
                )
              : Container(),
          SizedBox(width: 10),
          item.rentingDetails['perWeek'] != null
              ? ChoiceChip(
                  label: Text(
                    "Php " +
                        item.rentingDetails['perWeek'].toString() +
                        " / week",
                    style: TextStyle(fontSize: 18),
                  ),
                  selected: weeklyChip,
                  onSelected: (bool _weeklyChip) {
                    setState(() {
                      weeklyChip = _weeklyChip;
                      dailyChip = false;
                      hourlyChip = false;
                    });
                  },
                )
              : Container(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  goToCheckOut(BuildContext context, Item item, ItemDetailViewModel model) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: (MaterialButton(
          elevation: 5.0,
          child: Text("GO TO CHECKOUT"),
          onPressed: () {
            if (hourlyChip) {
              rentChosen = "Hourly";
            }
            if (dailyChip) {
              rentChosen = "Daily";
            }
            if (weeklyChip) {
              rentChosen = "Weekly";
            }
            useCloudCalculate(item, startRentDate, endRentDate);
            model.goToTransactionView(
                item, rentChosen, startRentDate, endRentDate);
          },
          //onPressed: () => model.goToTransactionView(item),
        )),
      );

  Future useCloudCalculate(
      Item item, DateTime startDate, DateTime endDate) async {
    double duration = _calculateRentingDuration(rentChosen, startDate, endDate);
    double rate;
    switch (rentChosen) {
      case "Daily":
        rate = double.parse(item.rentingDetails['perDay']);
        break;
      default:
    }
    print(duration.toString() + " ----- " + rate.toString());
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'computeDaily',
    );
    HttpsCallableResult resp = await callable.call(<String, dynamic>{
      'dailyRate': rate,
      'day': duration,
    });

    //resp = resp.data.toInt();
    print(resp.data);
  }

  double _calculateRentingDuration(
      var rentChosen, DateTime startDate, DateTime endDate) {
    switch (rentChosen) {
      // case "Hourly":
      //   rentingDuration = endTime.difference(startTime);
      //   return rentingDuration.inHours;
      //   break;
      case "Daily":
        rentingDuration = endDate.difference(startDate);
        return rentingDuration.inDays.toDouble();
        break;
      case "Weekly":
        break;
      default:
    }
  }

  //EOF
}
