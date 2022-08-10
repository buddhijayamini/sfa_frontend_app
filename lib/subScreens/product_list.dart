import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/products.dart';
import 'package:sfa_frontend_app/subScreens/single_product.dart';

class ProductList extends StatefulWidget {
  final String userdata;
  const ProductList({key, this.userdata}) : super(key: key);

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  String dropdownvalue = 'Product Category';
  var items = ['Product Category', 'Product Type'];

  Future<List<Products>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    String token = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };

    var url = "$baseURL/all_products";

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => Products.fromJson(e)).toList();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text("Error....",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
              content: const Text("No Data to load",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  color: Colors.redAccent,
                  child: const Text("Close",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.8),
            title: const Text("Error....",
                style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
            content: const Text("No Data to load / fail to load",
                style: TextStyle(color: Colors.red, fontSize: 20)),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                color: Colors.redAccent,
                child: const Text("Close",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  final controller = ScrollController();
  double offset = 0;
  Future<List<Products>> _albums;

  @override
  void initState() {
    _albums = fetchNotes();
    controller.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

List<Products> _prdList;
String _searchResult = '';
List<Products> usersFiltered = [];
TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(20.0),
                color: Colors.white,
                child: Card(
                  color: Colors.teal[500],
                  // ignore: avoid_unnecessary_containers
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        textDirection: TextDirection.ltr,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: 550,
                                    height: 150,
                                    margin: const EdgeInsets.only(left: 150),
                                    padding: const EdgeInsets.all(15.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 20,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          ButtonBar(
                                            children: <Widget>[
                                              DropdownButton(
                                                value: dropdownvalue,
                                                dropdownColor: Colors.white,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items:
                                                    items.map((String items) {
                                                  return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      25.0,
                                                                  color: Colors
                                                                      .blue)));
                                                }).toList(),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    dropdownvalue = newValue;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 220,
                                                height: 50,
                                                // ignore: deprecated_member_use
                                                child: TextField(
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.blue),
                                                  autocorrect: true,
                                                  decoration: InputDecoration(
                                                      hintText: 'Search....'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                               
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          FutureBuilder<List<Products>>(
                              future: _albums,
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData) {
                                  List<Products> data = snapshot.data;
                                  return SingleChildScrollView(
                                    padding: const EdgeInsets.all(2.0),
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      dividerThickness: 2,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .white, // red as border color
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      dataRowHeight: 150,
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      showCheckboxColumn: true,
                                      columnSpacing: 50,
                                      horizontalMargin: 20,
                                      onSelectAll: (value) {},
                                      // ignore: prefer_const_literals_to_create_immutables
                                      columns: [
                                        const DataColumn(
                                          label: Text(
                                            'Image',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Code',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Description',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Stock',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                      ],
                                      // the list should show the filtered list now
                                      rows: data
                                          .map((items) => DataRow(cells: [
                                                DataCell(
                                                  ((items.image.toString()) ==
                                                          'true')
                                                      ? Container(
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                items.image
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          decoration:
                                                              const BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                'assets/rbn.png',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SingleProduct(
                                                                    userdata: widget
                                                                        .userdata,
                                                                    prdId: items
                                                                        .id)));
                                                  },
                                                ),
                                                DataCell(
                                                  Text(
                                                    items.styleCode.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SingleProduct(
                                                                  userdata: widget
                                                                      .userdata,
                                                                  prdId: items
                                                                      .id)),
                                                    );
                                                  },
                                                ),
                                                DataCell(
                                                  Text(
                                                      items.styleCode
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SingleProduct(
                                                                    userdata: widget
                                                                        .userdata,
                                                                    prdId: items
                                                                        .id)));
                                                  },
                                                ),
                                                DataCell(
                                                  Text(items.avlQty.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SingleProduct(
                                                                    userdata: widget
                                                                        .userdata,
                                                                    prdId: items
                                                                        .id)));
                                                  },
                                                ),
                                              ]))
                                          .toList(),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return AlertDialog(
                                    title: const Text(
                                      'An Error Occured!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    content: Text(
                                      "${snapshot.error}",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      // ignore: deprecated_member_use
                                      FlatButton(
                                        child: const Text("Close",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                }
                                // By default, show a loading spinner.
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      CircularProgressIndicator(),
                                      SizedBox(height: 20),
                                      Text('This may take some time..')
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
