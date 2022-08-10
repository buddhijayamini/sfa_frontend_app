
class Orders {
  String code= '';
  int refId= 0;
  String outName = '';
  String date= '';
  int invId= 0;
  double orderValue = 0.00;
  List ordLine;

  Orders({
     this.code,
     this.refId,
     this.outName,
     this.date,
     this.invId,
     this.orderValue,
     this.ordLine,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      code: json['name'],
      refId: json['user_id'][0],
      outName:json['partner_id'][1],
      date:json['date_order'],
      invId:json['partner_invoice_id'][0],
      orderValue: json['amount_total'],
      ordLine:json['order_line'],
    );
}
}
