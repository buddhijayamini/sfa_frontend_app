import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
//import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/call_lost_load.dart';

class CallLost extends StatefulWidget {
  final String userdata;
  int vstId;
  CallLost({key, this.userdata, this.vstId}) : super(key: key);

  @override
  _CallLostState createState() => _CallLostState();
}

class _CallLostState extends State<CallLost> {
  final _formKey = GlobalKey<FormState>();
 // String dropdownvalue = 'Credit Issue';
  // var items = [
  //   'Credit Issue',
  //   'Owner Not IN',
  //   'Return Cheque',
  //   'Stocks Available',
  //   'Shop Close'
  // ];

   Future<List<LostLoad>> loadData() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/call.lost.reason";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => LostLoad.fromJson(e)).toList();
      
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

  Future senData() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int vstId = widget.vstId;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/call_lost_update/$vstId";

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: {
        "visit_status": "call_lost",
        "call_lost_reason": '3',
      },
    );

    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text("Updated....",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
              content: const Text("Successfully updated data...",
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
 Future<List<LostLoad>> _loadcalls;
   LostLoad selVal;

  @override
  void initState() {
   _loadcalls= loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final OrderItem todo = ModalRoute.of(context).settings.arguments;
    return Center(
        child: Container(
            padding: const EdgeInsets.all(13.0),
            color: Colors.teal[300],
            child: Card(
                color: Colors.white.withOpacity(0.8),
                shadowColor: Colors.tealAccent,
                // ignore: avoid_unnecessary_containers
                child: Form(
                    key: _formKey,
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
                                  height: 50.0,
                                ),
                                ButtonBar(
                                  buttonPadding:
                                      const EdgeInsets.only(left: 70),
                                  children: <Widget>[
                                    const Text('Reason',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            color: Colors.blue)),
                                    SizedBox(
                                      width: 250,
                                      height: 100,
                                      // ignore: deprecated_member_use
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FutureBuilder<List<LostLoad>>(
                                future: _loadcalls,
                                builder: (ctx, snapshot) {
                                  if (snapshot.hasData) {
                                    List<LostLoad> data = snapshot.data;
                                   
                                    return Center(
                                            child:  DropdownButton(
                                               isExpanded: true,
                                              hint: Text("Select Reason", style:  TextStyle(
                                                            fontSize: 28.0,
                                                            color: Colors.blue)),                                            
                                              items: data.map((items) {
                                                return DropdownMenuItem(
                                                    value:items.code, //items.code.toInt(),
                                                    child: Text(items.reason.toString(),
                                                        style:  TextStyle(
                                                            fontSize: 28.0,
                                                            color: Colors.blue)));
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selVal = newValue;
                                                });
                                              },
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
                                    // ignore: deprecated_member_use
                                  ],
                                ),
                              ],
                            )))))));
  }
}
