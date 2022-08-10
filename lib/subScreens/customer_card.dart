import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:sfa_frontend_app/models/all_outlets.dart';
import 'package:sfa_frontend_app/models/outlet_visit.dart';
import 'package:sfa_frontend_app/screens/login.dart';
import 'package:sfa_frontend_app/subScreens/call_lost.dart';
import 'package:sfa_frontend_app/subScreens/email_send.dart';
import 'package:sfa_frontend_app/subScreens/product_add.dart';
import 'package:sfa_frontend_app/subScreens/outlet_view.dart';

class CustomCard extends StatefulWidget {
  final String userdata;
  int outletId;
  int vstId;
  CustomCard({key, this.userdata, this.outletId, this.vstId}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final List<bool> _isSelected = [false, false, false, false, false];

  Future<List<AllOutlet>> _albums;

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

  Future<List<AllOutlet>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int outletId = widget.outletId;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/outlet/$outletId";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["result"] as List;

      return jsonResponse.map((e) => AllOutlet.fromJson(e)).toList();
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

  Future<List<OutletVisit>> visitCheck() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int visitId = widget.vstId;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/outlet.visit/$visitId)]";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson as List;

      return jsonResponse.map((e) => OutletVisit.fromJson(e)).toList();
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

  @override
  void initState() {
    _albums = fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final OrderItem todo = ModalRoute.of(context).settings.arguments;
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
        title: Text(
          'Outlet Card',
          style: TextStyle(fontSize: 35),
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
              iconSize: 40,
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
        child: FutureBuilder<List<AllOutlet>>(
          future: _albums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.teal[500],
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        snapshot.data[0].name.toString(),
                        textScaleFactor: 2.0,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                     SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding:  EdgeInsets.all(50),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: BorderSide(
                                      color: Colors.teal,
                                      width: 3,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      DataTable(
                                        columnSpacing: 30,
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.black;
                                          },
                                        ),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        onSelectAll: (value) {},
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Credit Limit',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Available Limit',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Pay Method',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Credit Terms',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                        rows: <DataRow>[
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].credit
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].avail
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              const DataCell(Center(
                                                child: Text(
                                                  'Cheque',
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].terms
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      DataTable(
                                        columnSpacing: 30,
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.black;
                                          },
                                        ),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        onSelectAll: (value) {},
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Retailer Class',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                        rows: <DataRow>[
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Center(
                                                child: Text(
                                                  (snapshot.data[0].grade !=
                                                          false)
                                                      ? snapshot.data[0].grade
                                                              .toString()
                                                              .toUpperCase() +
                                                          " Class"
                                                      : '-',
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      DataTable(
                                          columnSpacing: 30,
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                            (states) {
                                              return Colors.black;
                                            },
                                          ),
                                          dataRowColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.white),
                                          onSelectAll: (value) {},
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Total Exposure',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Book Oustanding',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Ret. Cheq',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'P.D Cheq',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                          rows: <DataRow>[
                                            DataRow(cells: <DataCell>[
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].expos
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].bkOut
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].returns
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: Text(
                                                  snapshot.data[0].pdc
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 24),
                                                ),
                                              )),
                                            ])
                                          ]),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                  height: 20,
                                ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                CustomToggleButtons(
                                  isSelected: _isSelected,
                                  color: Colors.indigo[900],
                                  borderRadius: 10,                              
                                  children: <Widget>[
                                    IconButton(
                                      icon:  Icon(Icons.business_center),
                                      iconSize: 50,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.8),
                                                title:  Text(
                                                    "Outlet Details",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 32)),
                                                content: OutletView(
                                                    userdata: widget.userdata,
                                                    outletId: widget.outletId),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.redAccent,
                                                    child: const Text("Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.call_rounded),
                                      iconSize: 50,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.8),
                                                title: Text("Call Lost",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 32)),
                                                content: SizedBox(
                                                  height: 300.0,
                                                  width: 600.0,
                                                  child: CallLost(
                                                    userdata: widget.userdata,
                                                    vstId: widget.vstId,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.redAccent,
                                                    child: const Text("Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    // FutureBuilder<List<OutletVisit>>(
                                    //   future: _albums1,
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.hasData &&
                                    //         snapshot.data[0].status.toString() !=
                                    //             "call_lost") {
                                    //       return
                                    IconButton(
                                      icon: const Icon(Icons.add_shopping_cart),
                                      iconSize: 50,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.8),
                                                title: const Text(
                                                    "Add Products",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 32)),
                                                content: const Text(
                                                    "Go to Add Products....",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 25)),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.teal[300],
                                                    child: const Text("Go",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddProducts(
                                                                    userdata: widget
                                                                        .userdata)),
                                                      );
                                                    },
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.redAccent,
                                                    child: const Text("Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    //     } else if (snapshot.hasError) {
                                    //       Text(
                                    //         snapshot.error.toString(),
                                    //       );
                                    //     }
                                    //     return const Center(
                                    //       child: CircularProgressIndicator(),
                                    //     );
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: const Icon(Icons.email_rounded),
                                      iconSize: 50,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.8),
                                                title: const Text("Email",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 32)),
                                                content: const Text(
                                                    "Go to send Email....",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 28)),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.teal[300],
                                                    child: const Text("Go",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EmailSender()),
                                                      );
                                                    },
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.redAccent,
                                                    child: const Text("Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.list_alt_rounded),
                                      iconSize: 50,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.8),
                                                title: const Text("Complains",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 32)),
                                                content: const Text(
                                                    "Go to Add Complains....",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 25)),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.teal[300],
                                                    child: const Text("Go",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      /* */
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           CallLost(
                                                      //               email: widget.email)),
                                                      // );
                                                    },
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    color: Colors.redAccent,
                                                    child: const Text("Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ],
                                  direction: Axis.vertical,
                                  onPressed: (index) {
                                    setState(() {
                                      _isSelected[index] = !_isSelected[index];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
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
      ),
    );
  }
}
