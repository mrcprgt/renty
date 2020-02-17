import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final void onPressed;

  const ItemTile({Key key, this.item, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(item.itemImages);
    return InkWell(
      child: Container(
        // width: MediaQuery.of(context).size.width / 2,
        // height: MediaQuery.of(context).size.width / 2,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Center(
                child: item.itemImages != null
                    ? CachedNetworkImage(
                        imageUrl: item.itemImages[0],
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                    : Center(
                        child: Icon(Icons.warning),
                      ),
              )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              text: ' / ' + item.rentType.toString(),
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12)),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 8.0,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGsReference(Item item) {
    final FirebaseStorage storage = FirebaseStorage.instance;
    var gsReference = storage.getReferenceFromUrl(item.itemImages);
    var gsurl = storage.ref().getDownloadURL();
    print(gsurl);
    return gsurl.toString();
  }
}
