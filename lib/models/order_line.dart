
class OrderLines {
  int id= 0;
  int refId= 0;
  String ordCode= '';
  int prdId= 0;
  String prdCode = '';
  double ordQty= 0.0;
  String date= '';
  double orderValue = 0.00;
  double ordLine  = 0.00;

  OrderLines({
    this.id,
    this.refId,
     this.ordCode,
     this.prdId,
     this.prdCode,
     this.ordQty,
     this.date,
     this.orderValue,
     this.ordLine,
  });

  factory OrderLines.fromJson(Map<String, dynamic> json) {
    return OrderLines(
      id:json['id'],
      refId:json['salesman_id'][0],
      ordCode: json['order_id'][1],
      prdId: json['product_id'][0],
      prdCode: json['product_id'][1],
      ordQty:json['product_uom_qty'],
      date:json['create_date'],
      orderValue: json['price_total'],
      ordLine:json['amt_to_invoice'],
    );
}
}
