import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/subScreens/outlet_list.dart';
import 'package:sfa_frontend_app/models/routes.dart';

class SalesScreen extends StatefulWidget {
  final String userdata;
  const SalesScreen({key, this.userdata}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // Get json result and convert it to model. Then add
  Future<List<Routes>> getRouteDetails() async {
    var parsedResponse = jsonDecode(widget.userdata);
    String token = parsedResponse["access_token"];
    int uid = parsedResponse["uid"];
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };
    var url =
        "$baseURL/ref_daily_route_list?filters=[('sales_rep','=', $uid),('date','=','2021-08-18')]";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;
      return jsonResponse.map((e) => Routes.fromJson(e)).toList();

     
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
  }

  final controller = ScrollController();
  double offset = 0;
  Future<List<Routes>> _albums;

  @override
  void initState() {
    _albums = getRouteDetails();
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
      body: FutureBuilder<List<Routes>>(
          future: _albums,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Routes> data = snapshot.data;
              return Center(
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
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const SizedBox(
                                height: 50.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 300, right: 50),
                                    child: Text(
                                      "Today:",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 50),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: DataTable(
                                  dataRowHeight: 100,
                                  dividerThickness: 2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                    (states) {
                                      return Colors.white;
                                    },
                                  ),
                                  sortColumnIndex: 0,
                                  sortAscending: true,
                                  showCheckboxColumn: true,
                                  columnSpacing: 150,
                                  onSelectAll: (value) {},
                                  // ignore: prefer_const_literals_to_create_immutables
                                  columns: [
                                    const DataColumn(
                                      label: Text(
                                        'Code',
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 28),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: Text(
                                        'Route Name',
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 28),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: Text(
                                        'No: of Outlets',
                                        style: TextStyle(
                                            color: Colors.teal, fontSize: 28),
                                      ),
                                    ),
                                  ],
                                  rows: data
                                      .map((items) => DataRow(cells: [
                                            DataCell(
                                              Text(
                                                items.routCode.toString(),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OutletList(
                                                            userdata:
                                                                widget.userdata,
                                                            routeId:
                                                                items.routId,
                                                          )),
                                                );
                                              },
                                            ),
                                            DataCell(
                                              Text(items.routName.toString(),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 26)),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OutletList(
                                                            userdata:
                                                                widget.userdata,
                                                            routeId:
                                                                items.routId,
                                                          )),
                                                );
                                              },
                                            ),
                                            DataCell(
                                              Text(
                                                  items.outlet.length
                                                      .toString(),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 26)),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OutletList(
                                                            userdata:
                                                                widget.userdata,
                                                            routeId: snapshot
                                                                .data[0].routId,
                                                          )),
                                                );
                                              },
                                            ),
                                          ]))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ))),
              ));
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
          }),
    );
  }
}
