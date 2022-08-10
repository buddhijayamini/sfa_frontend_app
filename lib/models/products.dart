class Products {
  int id = 0;
  String styleCode = '';
  double avlQty = 0.0;
  var image = '';
  List variant1;
  
  Products({
     this.id,
     this.styleCode,
     this.avlQty,
     this.image,
     this.variant1
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return  Products(
      id: json['id'],
      styleCode: json['style_code'],
       avlQty: json['product_variants'][0]['qty'],
       variant1:json['product_variants'],
      image: json['image'],      
    );
    
    //  var sum = 0;

// for (var i = 0; i < variant1.length; i++) {
//     sum += given_list[i];
//   }
 
 //return Products();
  }
}
