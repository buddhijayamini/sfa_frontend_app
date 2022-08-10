import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/rendering.dart';
import 'package:sfa_frontend_app/bloc/nav_drawer_bloc.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/models/all_outlets.dart';
import 'package:sfa_frontend_app/models/customer.dart';
import 'package:sfa_frontend_app/screens/login.dart';
import 'package:sfa_frontend_app/subScreens/customer_card.dart';
import 'package:sfa_frontend_app/models/outlets.dart';
import 'package:sfa_frontend_app/subScreens/log_out.dart';

class OutletList extends StatefulWidget {
  String userdata;
  int routeId;
  OutletList({key, this.userdata, this.routeId}) : super(key: key);

  @override
  _OutletListState createState() => _OutletListState();
}


class _OutletListState extends State<OutletList> {

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

  Future<List<Outlets>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int routeId = widget.routeId;
    print(routeId);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url =
        "$baseURL/outlet_visits?filters=[('date','=','2021-08-18'),('daily_routing_lines_id','=',$routeId)]";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => Outlets.fromJson(e)).toList();
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
  Future<List<Outlets>> _albums;
   

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
            "Outlet List",
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
              iconSize: 40,
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
              iconSize: 30,
              onPressed: () {
                logout();
              },
            ),
          ),
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            color: Colors.white,
            child: FutureBuilder<List<Outlets>>(
                future: _albums,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<Outlets> data = snapshot.data;
                    return  Card(
                        color: Colors.teal[500],
                        // ignore: avoid_unnecessary_containers
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                verticalDirection: VerticalDirection.down,
                                //textDirection: TextDirection.ltr,
                                //mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: DataTable(
                                      dividerThickness: 2,

                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
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
                                      dataRowHeight: 80,
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      showCheckboxColumn: true,
                                      columnSpacing: 100,
                                      onSelectAll: (value) {},
                                      // ignore: prefer_const_literals_to_create_immutables
                                      columns: [
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
                                            'Outlet Name',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Credit Limit',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Order Value',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                      ],
                                      rows: data
                                          .map((items) => DataRow(cells: [
                                                DataCell(
                                                  Text(
                                                    (items.code==false)? '- '
                                                   : items.code.toString(),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomCard(
                                                                  userdata: widget
                                                                      .userdata,
                                                                  vstId:
                                                                      items.id,
                                                                  outletId: items
                                                                      .outId)),
                                                    );
                                                  },
                                                ),
                                                DataCell(
                                                  Text(
                                                      items.outletName
                                                          .toString(),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomCard(
                                                                  userdata: widget
                                                                      .userdata,
                                                                  vstId:
                                                                      items.id,
                                                                  outletId: items
                                                                      .outId)),
                                                    );
                                                  },
                                                ),
                                                DataCell(                                                
                                                  Text(   items.creditLimit.toString(),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomCard(
                                                                  userdata: widget
                                                                      .userdata,
                                                                  vstId:
                                                                      items.id,
                                                                  outletId: items
                                                                      .outId)),
                                                    );
                                                  },
                                                ),
                                                DataCell(
                                                  Text(
                                                    (items.orderValue==false)? '- '
                                                   :items.orderValue.toString(),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomCard(
                                                                  userdata: widget
                                                                      .userdata,
                                                                  vstId:
                                                                      items.id,
                                                                  outletId: items
                                                                      .outId)),
                                                    );
                                                  },
                                                ),
                                              ]))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )));
        ;
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
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
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
                })));
  }
}
