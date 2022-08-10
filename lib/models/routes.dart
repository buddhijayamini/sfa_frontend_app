class Routes {
   int routId = 0;
   String date = '';
   List outlet;
   String routName = '';
    String routCode = '';

  Routes({
     this.routId,
     this.date,
     this.outlet,
     this.routCode,
     this.routName
  });


 factory  Routes.fromJson(Map<String, dynamic> json)
  {
    return  Routes(        
        routId:json['id'],
        date:json['date'],  
        routName:json['route_name'],
        routCode:json['route_code'],
        outlet: json['outlet_visit'],
  );
  }
}
