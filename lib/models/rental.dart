class Rental {
  final String id;
  final String itemID;
  final String lenderID;
  final String renterID;
  final String itemName;
  final String imgUrl;
  var rentChosen;
  var serviceFee;
  var totalPayable;
  Map<String, dynamic> rentDuration;
  DateTime startDate;
  DateTime endDate;

  Rental(
      {this.id,
      this.itemID,
      this.lenderID,
      this.renterID,
      this.itemName,
      this.imgUrl,
      this.rentChosen,
      this.serviceFee,
      this.totalPayable,
      this.rentDuration,
      this.startDate,
      this.endDate});

  static Rental fromMap(Map<dynamic, dynamic> map, String documentId) {
    if (map == null) return null;

    return Rental(
      itemID: map['item_ID'],
      lenderID: map['lender_ID'],
      renterID: map['renter_ID'],
      rentChosen: map['lender_def_price'],
      serviceFee: map['service_fee'],
      totalPayable: map['total_payable'],
      rentDuration: map['rent_duration'],
      startDate: map['rent_duration']['start_date'].toDate(),
      endDate: map['rent_duration']['end_date'].toDate(),
    );
  }
}
