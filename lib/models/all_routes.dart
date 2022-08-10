class AllRouteList {
   String id  = '';
   String name = '';
   String date = '';
   int refId = 0;
  String refName= '';

  AllRouteList({
     this.id,
     this.name,
     this.date,
     this.refId,
     this.refName,
  });


 factory  AllRouteList.fromJson(Map<String, dynamic> json)
  {
    return  AllRouteList(
        id: json['route_code'],
        name: json['route_name'],
        refId: json['sales_rep'][0],
        refName: json['sales_rep'][1],
        date: json["__last_update"],
  );
  }
}
