import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:sfa_frontend_app/models/excOrd.dart';
import 'package:sfa_frontend_app/screens/login.dart';

class AllExecutiveSummery extends StatefulWidget {
  final String userdata;
  const AllExecutiveSummery({key, this.userdata}) : super(key: key);

  @override
  _AllExecutiveSummeryState createState() => _AllExecutiveSummeryState();
}

class _AllExecutiveSummeryState extends State<AllExecutiveSummery> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();

  String dropdownvalue = 'Select';
  var items = ['Select', 'Product', 'Stock Category'];
  //final List<Retailer> _retail = <Retailer>[];

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

  Future<List<ExcOrders>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    parsedResponse = parsedResponse["access_token"];
    int refId = jsonDecode(widget.userdata)["uid"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': parsedResponse,
    };
    var url = "$baseURL/sale.order.line?filters=[('state','=','draft')]";
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);
      List jsonResponse = albumsJson["results"] as List;

      return jsonResponse.map((e) => ExcOrders.fromJson(e)).toList();
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

  final controller = ScrollController();
  double offset = 0;
  Future<List<ExcOrders>> _albums;

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
        title: Text(
          'All Excutive Summery List',
          style: TextStyle(fontSize: 35),
        ),
        centerTitle: true,
        elevation: 10,
        toolbarHeight: 100,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        bottomOpacity: 20,
        brightness: Brightness.dark,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(
                              height: 15.0,
                            ),
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
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text('Report Criteria',
                                                    style: TextStyle(
                                                        fontSize: 25.0,
                                                        color:
                                                            Colors.deepPurple)),
                                                DropdownButton(
                                                  value: dropdownvalue,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(2.0),
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder<List<ExcOrders>>(
                                  future: _albums,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasData) {
                                      List<ExcOrders> data = snapshot.data;
                                      return DataTable(
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
                                        dataRowHeight: 80,
                                        sortColumnIndex: 2,
                                        sortAscending: true,
                                        showCheckboxColumn: true,
                                        columnSpacing: 100,
                                        onSelectAll: (value) {},
                                        // ignore: prefer_const_literals_to_create_immutables
                                        columns: [
                                           const DataColumn(
                                            label: Text(
                                              'Ref. Name',
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 28),
                                            ),
                                          ),
                                          const DataColumn(
                                            label: Text(
                                              'Product / Category',
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 28),
                                            ),
                                          ),
                                          const DataColumn(
                                            label: Text(
                                              'QTY',
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 28),
                                            ),
                                          ),
                                          const DataColumn(
                                            label: Text(
                                              'Value',
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
                                                      items.refId.toString()+ "-" +items.refName.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ),
                                                    //   onTap: () {
                                                    // _showValues(items);
                                                    //  },
                                                  ),
                                                  DataCell(
                                                    Text( 
                                                      items.prdId.toString() +
                                                          ' - ' +
                                                          items.prdName
                                                              .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ),
                                                    //   onTap: () {
                                                    // _showValues(items);
                                                    //  },
                                                  ),
                                                  DataCell(
                                                    Text(
                                                       items.qty.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    // onTap: () {},
                                                  ),
                                                  DataCell(
                                                    Text(
                                                       items.price
                                                           .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                    // onTap: () {},
                                                  ),
                                                ]))
                                            .toList(),
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
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}
