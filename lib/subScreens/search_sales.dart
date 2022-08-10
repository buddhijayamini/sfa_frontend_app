import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/ref_orders.dart';
import 'package:sfa_frontend_app/screens/sales_inquery.dart';
import 'package:sfa_frontend_app/subScreens/order_copy.dart';

class SearchSalesInquiry extends StatefulWidget {
  final String userdata;
  const SearchSalesInquiry({key, this.userdata}) : super(key: key);

  @override
  _SearchSalesInquiryState createState() => _SearchSalesInquiryState();
}

class _SearchSalesInquiryState extends State<SearchSalesInquiry> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();

  String dropdownvalue = 'All Retailer';
  var items = [
    'All Retailer',
    'Stafford Garments Industry - Online',
    '4U - Kandy',
    'APV - Balangoda'
  ];
  double priceSum = 0;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate1) {
      setState(() {
        selectedDate1 = picked;
      });
    }
  }

  Future<List<RefOrders>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int refId = jsonDecode(widget.userdata)["uid"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/ref_sale_order/$refId";

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["result"] as List;

      return jsonResponse.map((e) => RefOrders.fromJson(e)).toList();
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
  Future<List<RefOrders>> _albums;

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

  // ListView getItemData(data) {
  //   List list = <Widget>[];

  //   for (var item in data) {
  //     list.add(
  //       Row(
  //       children: [
  //         Container(
  //             margin: EdgeInsets.all(12.0),
  //             padding: EdgeInsets.only(left: 30, right: 50),
  //             child: Text('${item[0]}',
  //                 style: TextStyle(color: Colors.blue, fontSize: 24))),
  //         Container(
  //           margin: EdgeInsets.all(12.0),
  //           padding: EdgeInsets.only(left: 10, right: 50),
  //           child: Text('${item[1]}',
  //               style: TextStyle(color: Colors.blue, fontSize: 24)),
  //         ),
  //         Container(
  //             margin: EdgeInsets.all(12.0),
  //             padding: EdgeInsets.only(left: 20, right: 50),
  //             child: Text('${item[3]}',
  //                 style: TextStyle(color: Colors.blue, fontSize: 24))),
  //         Container(
  //             margin: EdgeInsets.all(12.0),
  //             padding: EdgeInsets.only(left: 50, right: 20),
  //             child: Text('${item[4]}',
  //                 style: TextStyle(color: Colors.blue, fontSize: 24))),
  //         Container(
  //             margin: EdgeInsets.all(12.0),
  //             padding: EdgeInsets.only(left: 50, right: 20),
  //             child: Text('${item[4]}',
  //                 style: TextStyle(color: Colors.blue, fontSize: 24)))
  //       ],
  //     ));
  //   }

  //   return ListView(
  //       padding: const EdgeInsets.only(left: 50, right: 50), children: list);
  // }

  @override
  Widget build(BuildContext context) =>
 (dropdownvalue != 'All Retailer' )
                ?
      // Center(child:Text("hi aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),);
      Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: 500,
                                    height: 310,
                                    margin: const EdgeInsets.only(left: 150),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                  //      FutureBuilder<List<RefOrders>>(
                                  // future: _albums,
                                  // builder: (ctx, snapshot) {
                                  //   if (snapshot.hasData) {
                                  //     List<RefOrders> data = snapshot.data;
                                  //     var date1= DateTime.parse(snapshot.data[0].date);
                                  //     return  
                                       Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Retailer Name',
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      color:
                                                          Colors.deepPurple)),
                                                          //  DropdownButton(
                                                          //     items: data.map((item) {
                                                          //       return new DropdownMenuItem(
                                                          //         child: new Text(item['item_name']),
                                                          //         value: item['id'].toString(),
                                                          //       );
                                                          //     }).toList(),
                                                          //     onChanged: (newVal) {
                                                          //       setState(() {
                                                          //         _mySelection = newVal;
                                                          //       });
                                                          //     },
                                                          //     value: _mySelection,
                                                          //   ),
                                   
      
                                              DropdownButton(
                                                value: dropdownvalue,
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
                                            ],
                                          ),
                                          ButtonBar(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 220,
                                                height: 50,
                                                // ignore: deprecated_member_use
                                                child: RaisedButton(
                                                  color: Colors.teal[500],
                                                  child: Text(
                                                    'From-' "${selectedDate.toLocal()}"
                                                        .split(' ')[0],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ),
                                                  onPressed: () =>
                                                      _selectDate(context),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 220,
                                                height: 50,
                                                // ignore: deprecated_member_use
                                                child: RaisedButton(
                                                  color: Colors.teal[500],
                                                  child: Text(
                                                    'To-' "${selectedDate1.toLocal()}"
                                                        .split(' ')[0],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ),
                                                  onPressed: () =>
                                                      _selectDate1(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'QTY - ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Value - ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                             
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // color: Colors.white.withOpacity(0.7),
        elevation: 10,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Ord.NO.",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Date",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Retailer Name",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "QTY",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Value",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<RefOrders>>(
                future: _albums,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<RefOrders> data = snapshot.data;
                    return Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                                child: Center(
                                    child: Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.only(
                                            left: 30, right: 50),
                                        child: Text(
                                            '${data[0].code.toString()}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24))),
                                    Container(
                                      margin: EdgeInsets.all(12.0),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 50),
                                      child: Text('${data[0].date.toString()}',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 24)),
                                    ),
                                    Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.only(
                                            left: 20, right: 50),
                                        child: Text(
                                            '${data[0].outName.toString()}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24))),
                                    Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.only(
                                            left: 50, right: 20),
                                        child: Text(
                                            '${data[0].ordQty.toString()}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24))),
                                    Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.only(
                                            left: 50, right: 20),
                                        child: Text(
                                            '${data[0].orderValue.toString()}',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24)))
                                  ],
                                )),
                              );
                            }));
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
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
      ), ],
                            ),
      ):SalesInquiry();
}
