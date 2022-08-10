class AllOutlet {
  int code = 0;
  String name='';
  double credit = 0.00;
  int terms = 0;
  double avail = 0.00;
  double expos = 0.00;
  double pdc = 0.00;
  double returns = 0.00;
  double bkOut = 0.00;
  var grade;

  AllOutlet({
     this.code,
     this.name,
     this.grade,
     this.credit,
     this.terms,
     this.avail,
     this.expos,
     this.bkOut,
     this.pdc,
     this.returns,
  });

  factory AllOutlet.fromJson(Map<String, dynamic> json) {
    return AllOutlet(
      code: json['id'],
      name: json['name'],
      grade: json['outlet_class'],
      credit: json['credit_limit'],
      terms:json['credit_term'],
      avail: json['available_credit'],
      expos: json['outlet_exposure'],
      bkOut:json['outlet_outstanding'],
      pdc: json['pdc'],
      returns:json['rejected_pdc'],
    );
  }

 
}
