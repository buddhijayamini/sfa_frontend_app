class OutletOrders {
  int code = 0;
  String name='';
  double credit = 0.00;
  double avail = 0.00;
  int ordQty = 0;
  double orderValue = 0.00;
  var grade;

  OutletOrders({
     this.code,
     this.name,
     this.grade,
     this.credit,
     this.avail,
     this.ordQty,
     this.orderValue
  });

  factory OutletOrders.fromJson(Map<String, dynamic> json) {
    return OutletOrders(
      code: json['id'],
      name: json['name'],
      grade: json['customer_grade'],
      credit: json['credit_limit'],
      avail: json['credit'],
      ordQty: json['sale_order_count'],
      orderValue: json['total_invoiced'],
    );
  }

 
}
