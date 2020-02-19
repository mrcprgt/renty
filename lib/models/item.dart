class Item {
  final String id;
  final String itemName;
  final String itemDescription;
  var rentingDetails;
  var itemImages;
  var acquisition;
  bool isApproved;
  bool isRented;

  Item({
    this.id,
    this.itemName,
    this.itemDescription,
    this.rentingDetails,
    this.itemImages,
    this.isApproved,
    this.isRented,
    this.acquisition,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'item_id': id,
      'item_name': itemName,
      'item_description': itemDescription,
      'rent_details': rentingDetails,
      'pictures': itemImages,
      'is_approved': isApproved,
      'is_rented': isRented,
      'acquisition_map': acquisition,
    };
  }

  static Item fromMap(Map<dynamic, dynamic> map, String documentId) {
    if (map == null) return null;

    return Item(
      id: documentId,
      itemName: map['item_name'],
      itemDescription: map['item_description'],
      rentingDetails: map['rent_details'],
      itemImages: map['pictures'],
      isApproved: map['is_approved'],
      isRented: map['is_rented'],
      acquisition: map['acquisition_map'],
    );
  }
}
