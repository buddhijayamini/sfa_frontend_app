import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/customer.dart';

class OutletView extends StatefulWidget {
  final String userdata;
  int outletId;
  OutletView({key, this.userdata, this.outletId}) : super(key: key);

  @override
  _OutletViewState createState() => _OutletViewState();
}

class _OutletViewState extends State<OutletView> {
  Future<Customer> _albums;

  Future<Customer> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int outletId = widget.outletId;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/res.partner/$outletId";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = json.decode(response.body);
      for (var albumsJson in albumsJson) {
        Customer.fromJson(albumsJson);
      }

      int childId = albumsJson[0]["child_ids"][0];

      var url1 = "$baseURL/res.partner/$childId";
      var response1 = await http.get(
        Uri.parse(url1),
        headers: headers,
      );

      if (response1.statusCode == 200) {
        var albumsJson1 = json.decode(response1.body);
        for (var albumsJson1 in albumsJson1) {
       return  Customer.fromJson(albumsJson1);
        }
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text("Error....",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
              content: const Text("No Data to load ",
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

  @override
  void initState() {
    _albums = fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Customer>(
        future: _albums,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(13.0),
                    color: Colors.teal[300],
                    child: Card(
                        color: Colors.white.withOpacity(0.8),
                        shadowColor: Colors.tealAccent,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 250, bottom: 10),
                                          child: Text('Code:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              snapshot.data.code.toString(),
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 170, bottom: 10),
                                          child: Text('Short Name:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              snapshot.data.shortName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 240, bottom: 10),
                                          child: Text('Name:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              snapshot.data.name.toString(),
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 190, bottom: 10),
                                          child: Text('Address 1:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.address1 != false)
                                                  ? snapshot.data.address1
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 190, bottom: 10),
                                          child: Text('Address 2:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.address2 != false)
                                                  ? snapshot.data.address2
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 190, bottom: 10),
                                          child: Text('Address 3:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.address3 != false)
                                                  ? snapshot.data.address3
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 190, bottom: 10),
                                          child: Text('Address 4:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.address4 != false)
                                                  ? snapshot.data.address4
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 190, bottom: 10),
                                          child: Text('Address 5:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.address5 != false)
                                                  ? snapshot.data.address5
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 240, bottom: 10),
                                          child: Text('E-Mail:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.email != false)
                                                  ? snapshot.data.email
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 150, bottom: 10),
                                          child: Text('Telephone No:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.tel != false)
                                                  ? snapshot.data.tel
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 230, bottom: 10),
                                          child: Text('FAX No:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.fax != false)
                                                  ? snapshot.data.fax
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 60, bottom: 10),
                                          child: Text('Customer Contact No:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.cusPhone != false)
                                                  ? snapshot.data.cusPhone
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 150, bottom: 10),
                                          child: Text('Contact Name:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.contactName !=
                                                      false)
                                                  ? snapshot.data.contactName
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 170, bottom: 10),
                                          child: Text('Date of Birth:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.dob != false)
                                                  ? snapshot.data.dob
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 30, bottom: 10),
                                          child: Text('Customer Telephone No:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.cusTel != false)
                                                  ? snapshot.data.cusTel
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 110, bottom: 10),
                                          child: Text('Customer FAX No:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.cusFax != false)
                                                  ? snapshot.data.cusFax
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 130, bottom: 10),
                                          child: Text('Customer Email:',
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.purple)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                              (snapshot.data.cusEmail != false)
                                                  ? snapshot.data.cusEmail
                                                  : '-',
                                              style: const TextStyle(
                                                  fontSize: 28.0,
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))))));
          } else if (snapshot.hasError) {
            Text(
              snapshot.error.toString(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
}
