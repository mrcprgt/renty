class Operations {
  var categoriesMap;
  int serviceFee;
  //final String categoryImgUrl;

  Operations({this.categoriesMap, this.serviceFee});

  Map<dynamic, dynamic> toMap() {
    return {'categories': categoriesMap, 'service_fee_%': serviceFee};
  }

  static Operations fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return Operations(
        categoriesMap: map['categories'], serviceFee: map['service_fee_%']
        // categoryImgUrl: map['icon_url']
        );
  }
}
