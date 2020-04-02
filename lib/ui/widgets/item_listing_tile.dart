import 'package:flutter/material.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final void onPressed;

  const ItemTile({Key key, this.item, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          child: InkWell(
            splashColor: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                imageStack(item),
                descStack(item),
                ratingStack(item),
              ],
            ),
          ),
        ));
  }

  // InkWell(
  //     child: Card(
  //       elevation: 2.0,
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //       child: Column(
  //         //mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(
  //               left: 4.0,
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(
  //                   item.itemName,
  //                   overflow: TextOverflow.clip,
  //                   maxLines: 2,
  //                   style: TextStyle(
  //                       fontSize: 16.0,
  //                       fontWeight: FontWeight.w800,
  //                       color: Colors.black),
  //                 ),
  //                 SizedBox(
  //                   height: 2.0,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     RichText(
  //                       text: TextSpan(
  //                         text:
  //                             '₱' + item.rentingDetails['perDay'].toString(),
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.w400),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // SizedBox(
  //                 //   height: 8.0,
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  Widget imageStack(Item item) => CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: item.itemImages[0],
        placeholder: (context, url) => new Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );

  Widget descStack(Item item) => Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.itemName,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Text(product.price,
                //     style: TextStyle(
                //         color: Colors.yellow,
                //         fontSize: 18.0,
                //         fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      );

  Widget ratingStack(Item item) => Positioned(
        top: 0.0,
        left: 0.0,
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0))),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.pink,
                size: 10.0,
              ),
              SizedBox(
                width: 2.0,
              ),
              Text(
                "5",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              )
            ],
          ),
        ),
      );
}
