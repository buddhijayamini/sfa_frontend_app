class AccInvoice {
   int id  = 0;
   double bokOut = 0.0;
   double totExp = 0.0;
  List lines;

  AccInvoice({
     this.id,
     this.bokOut,
     this.totExp,
     this.lines,
  });


 factory  AccInvoice.fromJson(Map<String, dynamic> json)
  {
    return  AccInvoice(
        id: json['id'],
        bokOut: json['residual'],
        totExp: json['amount_total'],
        lines: json["invoice_line_ids"],
  );
  }
}
