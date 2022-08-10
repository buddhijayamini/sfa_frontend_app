import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/models/invoice.dart';
import 'package:sfa_frontend_app/models/order_line.dart';
import 'package:sfa_frontend_app/subScreens/call_lost.dart';

// ignore: camel_case_types
class viewOrderCopy extends StatefulWidget {
  final String userdata;
  String ordCode;
  String outName;

   viewOrderCopy({key,this.ordCode, this.userdata,this.outName}) : super(key: key);

  @override
  _viewOrderCopyState createState() => _viewOrderCopyState();
}


class _viewOrderCopyState extends State<viewOrderCopy> {

  Future<List<OrderLines>> getInvDetails() async {
    var parsedResponse = jsonDecode(widget.userdata);
    String token = parsedResponse["access_token"];
     String OrderId=widget.ordCode;
     int refId = jsonDecode(widget.userdata)["uid"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };

    var url = "$baseURL/sale.order.line?filters=[('order_id','=','$OrderId')]";//$OrderId)]";
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => OrderLines.fromJson(e)).toList();
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
  Future<List<OrderLines>> _albums;

  @override
  void initState() {
    _albums = getInvDetails();
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
    return Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(13.0),
            color: Colors.teal[300],
            child: Card(
              color: Colors.white.withOpacity(0.8),
              shadowColor: Colors.deepPurpleAccent,
              // ignore: avoid_unnecessary_containers
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: 
                  FutureBuilder<List<OrderLines>>(
                      future: _albums,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String ordDate = snapshot.data[0].date.toString();
                          String ordTime = snapshot.data[0].date.toString();
                          String refId = snapshot.data[0].refId.toString();
                          String Outlet = widget.outName;

                          return   Column(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                             Container(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Stafford Garment Industries (Pvt) ltd",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 23)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("No:....,Negambo Road,",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left:10,top:0),
                                      child: Text("Paliyagoda",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("4U-Kandy",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top:15,left: 10,right: 10,bottom: 5),
                                      child: Text("Retailer Name- $Outlet",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("Order-Copy",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 23)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Date: $ordDate",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.all(10),
                                    //   child: Text("Time- $ordTime",
                                    //       //items.routeName.toString(),
                                    //       style: TextStyle(
                                    //           color: Colors.blue,
                                    //           fontSize: 23)),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Prefix- $refId",
                                          //items.routeName.toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 23)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      DataTable(
                        sortColumnIndex: 2,
                        dataRowHeight: 50,
                        sortAscending: true,
                        showCheckboxColumn: true,
                        columnSpacing: 50,
                        onSelectAll: (value) {},
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Prd. Code',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 25),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Description',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 25),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Price',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 25),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Qty',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 25),
                            ),),
                              DataColumn(
                            label: Text(
                              'Line Value',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 25),
                            ),
                          ),
                        ],
                        // the list should show the filtered list now
                        rows:snapshot.data.map((items) => DataRow(cells: [
                              DataCell(
                                 Text(items.prdId.toString(),
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 23)),
                              
                              ),
                              DataCell(
                                Text(items.prdCode,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 23)),
                                ),
                             
                              DataCell(
                               Text(
                                      items.orderValue.toString(),
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 23)),
                                ),
                             
                              DataCell(
                                Text(items.ordQty.toString(),
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 23)),
                                ),
                            
                               DataCell(
                                Text(items.ordLine.toString(),
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 23)),
                                
                              ),
                             ]))
                                          .toList(),
                      ),
                    ],
               
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
                ),
              ),
            )));
  }
}
