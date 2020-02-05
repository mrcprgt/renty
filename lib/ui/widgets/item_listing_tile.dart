import 'package:flutter/material.dart';
import 'package:renty_crud_version/models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  //final Function onDeleteItem;
  const ItemTile({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.network(
              'https://flutter.io/images/catalog-widget-placeholder.png',
            ),
            height: 50.0,
            width: MediaQuery.of(context).size.width / 2.2,
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.itemName,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '₱' + item.rentRate.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: ' / ' + item.rentType.toString(),
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12)),
                    )
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
