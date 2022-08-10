import 'dart:async';
import 'dart:convert';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/providers/all_routes_api.dart';
import 'package:sfa_frontend_app/models/all_routes.dart';

class AllRoute extends StatefulWidget {
  final String userdata;
   AllRoute({key, this.userdata}) : super(key: key);

  @override
  _AllRouteState createState() => _AllRouteState();
}

class _AllRouteState extends State<AllRoute> {

  final controller = ScrollController();
  double offset = 0;
  Future<List<AllRouteList>> _albums;

Future<List<AllRouteList>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int refId = jsonDecode(widget.userdata)["uid"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/distribution.routes?filters=[('sales_rep','=',$refId)]";

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => AllRouteList.fromJson(e)).toList();
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
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(13.0),
                color: Colors.white,
                child: Card(
                    color: Colors.teal[500],
                    // ignore: avoid_unnecessary_containers
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(
                              height: 50.0,
                            ),
                            FutureBuilder<List<AllRouteList>>(
                                future: _albums,
                                builder: (ctx, snapshot) {
                                  if (snapshot.hasData) {
                                    List<AllRouteList> data = snapshot.data;
                                    var date1 =
                                        DateTime.parse(snapshot.data[0].date);
                                    return Padding( 
                                      padding:EdgeInsets.only(left: 30),
                                      child:DataTable(
                                      dataRowHeight: 80,
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
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      showCheckboxColumn: true,
                                      columnSpacing: 180,
                                      onSelectAll: (value) {},
                                      // ignore: prefer_const_literals_to_create_immutables
                                      columns: [
                                        const DataColumn(
                                          label: Text(
                                            'Route Code',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Route Name',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            'Date',
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
                                                  Text(
                                                    items.id.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                  //   onTap: () {
                                                  // _showValues(items);
                                                  //  },
                                                ),
                                                DataCell(
                                                  Text(items.name.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  // onTap: () {},
                                                ),
                                                DataCell(
                                                  Text(
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(date1),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25)),
                                                  // onTap: () {},
                                                ),
                                              ]))
                                          .toList(),
                                      ),  );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                    )))));
  }
}
