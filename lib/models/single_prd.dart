import 'package:flutter/material.dart';

class SngProducts {
  int id = 0;
  String styleCode = '';
  var variants;

  SngProducts(
      {this.id,
      this.styleCode,
      this.variants,
  });

  factory SngProducts.fromJson(Map<String, dynamic> json) {
    var products = SngProducts(
        id: json['id'], 
        styleCode: json['style_code'], 
        variants: []
        );

    var variants = [];

    for (var product in json['product_variants']) {
      variants.add(
        [
          product["id"],
         product["product_code"], 
         product["size"], 
         product["qty"],
          product["price"]
      ]);
      // variants.add(
      //   DataRow(cells: [
      //     DataCell(
      //       Text(
      //         product["id"].toString(),
      //         softWrap: true,
      //         overflow: TextOverflow.ellipsis,
      //         style: const TextStyle(color: Colors.white, fontSize: 25),
      //       ),
      //     ),
      //     DataCell(
      //       Text(
      //         product["product_code"].toString(),
      //         softWrap: true,
      //         overflow: TextOverflow.ellipsis,
      //         style: const TextStyle(color: Colors.white, fontSize: 25),
      //       ),
      //     ),
      //     DataCell(
      //       Text(
      //         product["size"].toString(),
      //         softWrap: true,
      //         overflow: TextOverflow.ellipsis,
      //         style: const TextStyle(color: Colors.white, fontSize: 25),
      //       ),
      //     ),
      //     DataCell(
      //       Text(
      //         product["qty"].toString(),
      //         softWrap: true,
      //         overflow: TextOverflow.ellipsis,
      //         style: const TextStyle(color: Colors.white, fontSize: 25),
      //       ),
      //     ),
        
      //   ]),
     //);
    }

   products.variants = variants;

    return products;
  }
}
