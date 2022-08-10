class Outlets {
  int id= 0;
  int outId= 0;
  var code;
  String outletName = '';
  double creditLimit= 0.0;
  var orderValue;

  Outlets({
    this.id,
    this.outId,
     this.code,
     this.outletName,
     this.creditLimit,
     this.orderValue,
  });

  factory Outlets.fromJson(Map<String, dynamic> json) {
    return Outlets(
      id:json['id'],
      outId: json['outlet_id'],
      code: json['outlet_code'],
      outletName: json['outlet_name'],
      creditLimit: json['credit_limit'],
      orderValue: json['order_values'],
    );
}
}
