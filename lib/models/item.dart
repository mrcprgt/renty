class Item {
  final String id;
  final String itemName;
  final String description;
  final String rentType;
  var itemImages;
  var rentRate;

  // bool isApproved;
  // bool isRented;
  String acquisitionType;

  DateTime acquisitionTime;

  Item(
      {this.id,
      this.itemName,
      this.description,
      this.rentType,
      this.rentRate,
      this.itemImages,
      // this.isApproved,
      // this.isRented,
      this.acquisitionType,
      this.acquisitionTime});

  Map<dynamic, dynamic> toMap() {
    return {
      'item_id': id,
      'item_name': itemName,
      'description': description,
      'rent_type': rentType,
      'rent_rate': rentRate,
      'item_images': itemImages,
      // 'is_approved': isApproved,
      // 'is_rented': isRented,
      'acquisition_type': acquisitionType,
      'acquisition_time': acquisitionTime,
    };
  }

  static Item fromMap(Map<dynamic, dynamic> map, String documentId) {
    if (map == null) return null;

    return Item(
      id: documentId,
      itemName: map['item_name'],
      description: map['description'],
      rentType: map['rent_type'],
      rentRate: map['rent_rate'],
      itemImages: map['item_images'],
      // isApproved: map['is_approved'],
      // isRented: map['is_rented'],
      acquisitionType: map['acquisition_type'],
      acquisitionTime: map['acquisiton_time'],
    );
  }
}
