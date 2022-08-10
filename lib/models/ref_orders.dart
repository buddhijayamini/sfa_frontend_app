
class RefOrders {
  String code= '';
  String outName = '';
  String date= '';
  double orderValue = 0.00;
  double ordQty= 0.00;

  RefOrders({
     this.code,
     this.outName,
     this.date,
     this.orderValue,
     this.ordQty,
  });

  factory RefOrders.fromJson(Map<String, dynamic> json) {
    return RefOrders(
      code: json['code'],
      outName:json['retailer_name'],
      date:json['date'],
      orderValue: json['total_amount'],
      ordQty:json['total_qty'],
    );
}
}
