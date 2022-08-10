class PdcCheq {
   int id  = 0;
   String state = '';
   double amount = 0.0;

  PdcCheq({
     this.id,
     this.state,
     this.amount,
  });


 factory  PdcCheq.fromJson(Map<String, dynamic> json)
  {
    return  PdcCheq(
        id: json['id'],
        state: json['state'],
        amount: json['amount'],
  );
  }
}
