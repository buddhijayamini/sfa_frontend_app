//import 'package:intl/intl.dart';

class Invoice {
  int code= 0;
  int refId= 0;
  String refName = '';
  String date= '';//DateFormat("yyyy-MM-dd").format(DateTime.now());
  int prdId= 0;
  int invId= 0;
  String prdName= '';
  double ordQty= 0.00;
  double prdQty= 0.00;
  double prdPrice = 0.00;
  double orderValue = 0.00;

  Invoice({
     this.code,
     this.refId,
     this.refName,
     this.date,
     this.prdId,
     this.invId,
     this.prdName,
     this.ordQty,
     this.prdQty,
     this.prdPrice,
     this.orderValue,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      code: json['order_id'][0],
      refId: json['salesman_id'][0],
      refName: json['branch_id'][1],
      date:json['create_date'],
      invId:json['invoice_ids'],
      prdId: json['product_id'][0],
      prdName:json['product_id'][1],
      ordQty: json['qty_to_invoice'],
      prdQty: json['product_uom_qty'],
      prdPrice: json['price_total'],
      orderValue: json['amt_to_invoice'],
    );
}
}
