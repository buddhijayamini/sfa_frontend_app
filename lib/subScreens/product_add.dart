import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:sfa_frontend_app/models/outlet_orders.dart';
import 'package:sfa_frontend_app/models/products.dart';
import 'package:sfa_frontend_app/screens/login.dart';
import 'package:sfa_frontend_app/subScreens/add_cart.dart';
import 'package:sfa_frontend_app/subScreens/product_view.dart';

class AddProducts extends StatefulWidget {
  final String userdata;
  const AddProducts({key, this.userdata}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<Products> _prdData = [];
  Future<OutletOrders> _albums1;

  String dropdownvalue = 'Style';
  var items = ['Style', 'ST00937', 'ST00938', 'ST00939', 'ST00940'];
  String dropdownvalue1 = 'Size';
  var items1 = ['Size', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

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

  Future<OutletOrders> getOrdDetails() async {
    var parsedResponse = jsonDecode(widget.userdata);
    String token = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };
    var url = "$baseURL/res.partner?id=1&filters=[('outlet','!=',False)]";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = json.decode(response.body);
      for (var albumsJson in albumsJson) {
        return OutletOrders.fromJson(albumsJson);
      }
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
    return  showDialog(
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

  Future<List<Products>> getPrdDetails() async {
    var parsedResponse = jsonDecode(widget.userdata);
    String token = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };
    var url = "$baseURL/all_products";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

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
  return  showDialog(
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
    _albums = getPrdDetails();
    _albums1 = getOrdDetails();
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //ignore: deprecated_member_use
          leading:  IconButton(
              icon: Icon(Icons.menu),
              color: Colors.indigo[900],
              iconSize: 60,
              onPressed: () {
             // Scaffold.of(context).hasDrawer;
              },
            ),
        title: const Text(
          "Add Products",
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
            padding: EdgeInsets.only(right: 5,left: 5),
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
            padding: EdgeInsets.only(right: 5,left: 5),
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
          color: Colors.white,
          child: Card(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    FutureBuilder<OutletOrders>(
                      future: _albums1,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                      
                          return Column(
                            children: <Widget>[
                            ButtonBar(
                              children: <Widget>[
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 50.0, right: 10),
                                  child: Text(
                                    "Credit Limit : ",
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data.credit.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 120.0, right: 10),
                                  child: Text(
                                    "Order Value : ",
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data.orderValue.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: IconButton(
                                      icon: const Icon(
                                          Icons.add_shopping_cart_rounded),
                                      iconSize: 80,
                                      color: Colors.teal,
                                      onPressed: () {  
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddCart(
                                                      userdata: widget.userdata,
                                                      // prdId: snapshot.data[0].id,
                                                      // varient: getItemData(snapshot.data[0].variants),
                                                    ),),);                                     
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (BuildContext context) {
                                        //       return AlertDialog(
                                        //         backgroundColor: Colors.white
                                        //             .withOpacity(0.8),
                                        //         title: const Text("View Cart",
                                        //             style: TextStyle(
                                        //                 color:
                                        //                     Colors.deepPurple,
                                        //                 fontSize: 25)),
                                        //         content:  AddCart(
                                        //           userdata: '',
                                        //         ),
                                        //         actions: <Widget>[
                                        //           // ignore: deprecated_member_use
                                        //           FlatButton(
                                        //             color: Colors.redAccent,
                                        //             child: const Text("Close",
                                        //                 style: TextStyle(
                                        //                     color: Colors.white,
                                        //                     fontSize: 20)),
                                        //             onPressed: () {
                                        //               Navigator.of(context)
                                        //                   .pop();
                                        //             },
                                        //           ),
                                        //         ],
                                        //       );
                                           // });
                                      }),
                                ),
                              ],
                            ),
                            ButtonBar(
                              children: <Widget>[
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 50.0, right: 10),
                                  child: Text(
                                    "Available Credit : ",
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data.avail.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 100.0, right: 10),
                                  child: Text(
                                    "Order QTY : ",
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 220.0),
                                  child: Text(
                                    snapshot.data.ordQty.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]);
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
                    Container(
                      color: Colors.teal[400],
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: ButtonBar(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 50, right: 80),
                            child: DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownvalue = newValue;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50, right: 80),
                            child: DropdownButton(
                              value: dropdownvalue1,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items1.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,
                                        style: const TextStyle(
                                          fontSize: 25.0,
                                        )));
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownvalue1 = newValue;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 220,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontSize: 25),
                              autocorrect: true,
                              decoration:
                                  InputDecoration(hintText: 'Search....'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                        child: FutureBuilder<List<Products>>(
                      future: _albums,
                      builder: (BuildContext context,
                              AsyncSnapshot<List<Products>> snapshot) =>
                          snapshot.hasData
                              ? GridView.builder(
                                  physics: const ScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index) {
  //                                      totQty(){
  //   double sumqt = 0;
  //                                    var varLst = snapshot.data[index].variant1;
  //                                    double varient_list1 = snapshot.data[index].variant1[0]['qty'];
                                      
  //                                     if(varLst.length == 0 ){                             
  //                                       sumqt = varient_list1;
  //                                     }else if(varLst.length == 1 ){
  //                                        double varient_list2 = snapshot.data[index].variant1[1]['qty'];
  //                                       sumqt = varient_list1 + varient_list2;
  //                                     }else if(varLst.length == 2 ){
  //                                        double varient_list2 = snapshot.data[index].variant1[1]['qty'];
  //                                          double varient_list3 = snapshot.data[index].variant1[2]['qty'];
  //                                       sumqt = varient_list1 + varient_list2 + varient_list3;
  //                                     }else if(varLst.length == 3 ){
  //                                        double varient_list2 = snapshot.data[index].variant1[1]['qty'];
  //                                        double varient_list3 = snapshot.data[index].variant1[2]['qty'];
  //                                        double varient_list4 = snapshot.data[index].variant1[3]['qty'];
  //                                       sumqt = varient_list1 + varient_list2 + varient_list3 + varient_list4;
  //                                     }
  //                                     return sumqt;
                           
  // }

                                    return Container(
                                      width:  MediaQuery.of(context).size.width/2,
                                      padding: const EdgeInsets.all(20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // ignore: avoid_print
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductView(
                                                      userdata: widget.userdata,
                                                      prdId: snapshot.data[index].id,
                                                    )),
                                          );
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          color: Colors.teal[400],
                                          elevation: 10,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 80),
                                                    child: Image.asset(
                                                      'assets/rbn.png',
                                                      width: 150.0,
                                                      height: 250.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 150),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                         Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .styleCode
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              softWrap: true,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      26.0,
                                                                  color: Colors
                                                                      .white)),),
                                                         Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                              'Avl. QTY: ', //$totQty()',
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              softWrap: true,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .white)),),
                                                         Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                              'Ord. QTY:  0.00',
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              softWrap: true,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      24.0,
                                                                  color: Colors
                                                                      .white)),),
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : const Center(
                                  child: CircularProgressIndicator()),
                    )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
