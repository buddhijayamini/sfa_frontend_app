
class ExcOrders {
  int code= 0;
  String prdName= '';
  String refName= '';
  int refId= 0;
  int prdId = 0;
  double qty = 0.00;
   double price = 0.00;

  ExcOrders({
     this.code,
     this.prdName,
     this.prdId,
     this.qty,
     this.price,
     this.refId,
     this.refName,
  });

  factory ExcOrders.fromJson(Map<String, dynamic> json) {
    return ExcOrders(
     code: json['id'],
       prdName: json['product_id'][1],
       prdId:json['product_id'][0],
       qty:json['product_uom_qty'],
       price:json['price_total'],
       refId:json['salesman_id'][0],
      refName:json['salesman_id'][1],
    );
}
}
