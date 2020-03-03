import 'package:flutter/material.dart';

class RentingBottomSheet extends StatefulWidget {
  @override
  _RentingBottomSheetState createState() => _RentingBottomSheetState();
}

class _RentingBottomSheetState extends State<RentingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(32),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Rent Rate'),
            Row(
              children: <Widget>[
                bottomSheetForm(item),
              ],
            )
          ]),
    );
  }
}
