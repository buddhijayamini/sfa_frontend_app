import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/single_prd.dart';
import 'package:sfa_frontend_app/screens/login.dart';
import 'package:sfa_frontend_app/subScreens/order_copy.dart';

class AddCart extends StatefulWidget {
  final String userdata;
  final int prdId;
  var varient;
  AddCart({key, this.userdata, this.prdId, this.varient}) : super(key: key);

  @override
  _AddCartState createState() => _AddCartState();
}

_read() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/save_prd_data.txt');
    var cartData = await file.readAsString();
    print(cartData); //.indexOf('varint').toString());
    return cartData;
  } catch (e) {
    print("Couldn't read file");
  }
}

_save() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/add_cart_data.txt');
  // final server =
  // ''; // 'https://stafford.codeso.lk/api';// serverController.text;
  //final db = ''; //stafford.codeso.lk';// dbController.text;
  await file.writeAsString(""); //"baseUrl:"+server+',\n'+"db:"+db);
  print('saved');
}

class _AddCartState extends State<AddCart> {
  List<DataRow> _rowList = []; //_read();
  final _formKey = GlobalKey<FormState>();

  Future<List<SngProducts>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    int prdId = widget.prdId;

    String token = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };

    var url = "$baseURL/product/$prdId";

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["result"] as List;

      return jsonResponse.map((e) => SngProducts.fromJson(e)).toList();
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

  Future<List<SngProducts>> _albums;

  Future senData() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    
    final response = await http.post(
      Uri.parse("$baseURL/sale.order"),
      headers: headers,
      body: {
        "partner_id": "17",
        "partner_invoice_id": "1",
        "partner_shopping_id": '1',
        "picking_policy": 'direct',
      },
    );
    if (response.statusCode == 200) {  
       var ordId = jsonDecode(response.body);
        ordId = ordId["id"];
    print(ordId);

      final response1 = await http.post(
      Uri.parse("$baseURL/sale.order.line"),
      headers: headers,
      body: {
        "product_id": widget.prdId.toString(),
        "product_uom_qty": "20",
        "price_unit": "1000",
        "name": '',
        "order_id": ordId.toString(),
      },
    );  
     if (response1.statusCode == 200) {  
        var ordId1 = jsonDecode(response.body);
        ordId1 = ordId1["order_id"];
print(ordId1);
          return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text("Saved....",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
              content: const Text("Successfully saved data...",
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
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
    } else {
      return showDialog(
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
  }

  ListView getItemData(data) {
    List list = <Widget>[];

    for (var item in data) {
      list.add(
        Table(
          children: [
            TableRow(children: [
              Text('Item',
                  style: TextStyle(color: Colors.purple, fontSize: 22)),
              Text('Size',
                  style: TextStyle(color: Colors.purple, fontSize: 22)),
              Text('Qty', style: TextStyle(color: Colors.purple, fontSize: 22)),
              Text('Order',
                  style: TextStyle(color: Colors.purple, fontSize: 22)),
            ]),
            TableRow(children: [
              Text(widget.prdId.toString(),
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              Text('${item[2]}',
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              Text('${item[3]}',
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              Text('${item[4]}',
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
            ]),
          ],
        ),
      );
    }

    return ListView(
        padding: const EdgeInsets.only(left: 50, right: 50), children: list);
  }

  Future logout() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/auth/delete_tokens";

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginUser(),
        ),
        (Route route) => false,
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text("Error....",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
              content: const Text("Login Faild",
                  style: TextStyle(color: Colors.red, fontSize: 23)),
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
  }

  @override
  void initState() {
    _albums = fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //ignore: deprecated_member_use
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.indigo[900],
          iconSize: 60,
          onPressed: () {
            // Scaffold.of(context).hasDrawer;
          },
        ),
        title: const Text(
          "Add to Cart",
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        centerTitle: true,
        elevation: 10,
        toolbarHeight: 100,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        bottomOpacity: 20,
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            padding: EdgeInsets.only(right: 5, left: 5),
            color: Colors.indigo[900],
            shape: CircleBorder(),
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.white,
              iconSize: 50,
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            padding: EdgeInsets.only(right: 5, left: 5),
            color: Colors.indigo[900],
            shape: CircleBorder(),
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              iconSize: 50,
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(13.0),
          color: Colors.teal[300],
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder<List<SngProducts>>(
                    future: _albums, //Future.wait([_albums, _box]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return  Container(
                                  padding: EdgeInsets.only(left: 50, right: 50),
                                  height: 1000,
                                  child:  ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 300,
                                color: Colors.white,
                                child: Center(
                                  child: getItemData(
                                      snapshot.data[index].variants),
                                ),
                              );
                            }));
                      } else if (snapshot.hasError) {
                        Text(
                          snapshot.error.toString(),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        senData();
                      },
                      color: Colors.teal[300],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                         showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        0.8),
                                                            title: const Text(
                                                                "View Order",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    fontSize:
                                                                        25)),
                                                            content: viewOrderCopy(
                                                                userdata: widget
                                                                    .userdata,
                                                                ordCode: "46",
                                                                outName:"17", 
                                                                    ),
                                                            actions: <Widget>[
                                                              // ignore: deprecated_member_use
                                                              FlatButton(
                                                                color: Colors
                                                                    .redAccent,
                                                                child: const Text(
                                                                    "Close",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20)),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                      },
                      color: Colors.teal[300],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'View Invoice',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
