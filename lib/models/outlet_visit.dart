class OutletVisit {
   String id  = '';
   int outId = 0;
   String status = '';
   int resId = 0;
  String resName= '';
  int lineId= 0;

  OutletVisit({
     this.id,
     this.outId,
     this.status,
     this.resId,
     this.resName,
     this.lineId,
  });


 factory  OutletVisit.fromJson(Map<String, dynamic> json)
  {
    return  OutletVisit(
        id: json['id'],
        outId: json['outlet_name'][0],
        status: json['visit_status'],
        resId: json['call_lost_reason'][0],
        resName: json['call_lost_reason'][1],
        lineId: json["daily_routing_lines_id"][0],
  );
  }
}
