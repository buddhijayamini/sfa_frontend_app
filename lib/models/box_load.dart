class BoxLoad {
  int id = 0;
  String boxName = '';
  String strctQty = '';
  int strctId = 0;
  String strctName = '';
 
  BoxLoad({
     this.id,
     this.boxName,
     this.strctQty,
     this.strctId,
     this.strctName,
  });

  factory BoxLoad.fromJson(Map<String, dynamic> json) {
    return BoxLoad(
      id: json['id'],
      boxName: json['name'],
      strctQty: json['structure'][0]['qty'],
      strctId: json['structure'][0]['id'],
      strctName: json['structure'][0]['name'],
    );
  }
}
