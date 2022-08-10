class Customer {
  int code = 0;
  String shortName = '';
  String name = '';
  var address1;
  var address2;
  var address3;
  var address4;
  var address5;
  var email;
  var tel;
  var fax;
  var cusPhone;
  var contactName;
  var dob;
  var cusTel;
  var cusFax;
  var cusEmail;
  List childIds;

  Customer({
    this.code,
    this.shortName,
    this.name,
    this.address1,
    this.address2,
    this.address3,
    this.address4,
    this.address5,
    this.email,
    this.tel,
    this.fax,
    this.cusPhone,
    this.contactName,
    this.dob,
    this.cusTel,
    this.cusFax,
    this.cusEmail,
    this.childIds,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      code:(json['parent_id']==false)?0:json['parent_id'][0] ,
      shortName: json['name'],
      name: json['display_name'],
      address1: json['street'],
      address2: json['street2'],
      address3: json['zip'],
      address4: json['city'],
      address5: (json['state_id']==false)?'':json['state_id'][0],
      email: json['email'],
      tel: json['phone'],
      fax: json['fax_no'],
      cusPhone: json['phone'],
      contactName:json['name'],
      dob: json['dob'],
      cusTel: json['mobile'],
      cusFax: json['fax_no'],
      cusEmail: json['email'],
      childIds: json['child_ids']
    );
  }

}
