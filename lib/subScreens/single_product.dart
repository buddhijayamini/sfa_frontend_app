import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:sfa_frontend_app/models/single_prd.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:sfa_frontend_app/models/products.dart';

class SingleProduct extends StatefulWidget {
  final String userdata;
  int prdId;
  SingleProduct({key, this.prdId, this.userdata}) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  Future<List<SngProducts>> fetchNotes() async {
    var parsedResponse = jsonDecode(widget.userdata);
    int prdId = widget.prdId;

    String token = parsedResponse["access_token"];

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      'Charset': 'utf-8',
      'access_token': token,
    };

    var url = "$baseURL/product/$prdId";

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var albumsJson = jsonDecode(response.body);

      List jsonResponse = albumsJson["result"] as List;

      return jsonResponse.map((e) => SngProducts.fromJson(e)).toList();
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
  Future<List<SngProducts>> _albums;

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

  ListView getItemData(data) {
    List list = <Widget>[];

    for (var item in data) {
      list.add(
        Row(
        children: [
          Container(
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 30,right: 50),
              child: Text('${item[0]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Container(
            margin: EdgeInsets.all(12.0),
            padding: EdgeInsets.only(left: 10,right: 50),
            child: Text('${item[1]}',
                style: TextStyle(color: Colors.blue, fontSize: 24)),
          ),
          Container(
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 20,right: 50),
              child: Text('${item[3]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Container(
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 50,right: 20),
              child: Text('${item[4]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
        ],
      ));
    }

    return ListView(
        padding: const EdgeInsets.only(left: 50, right: 50), children: list);
  }

  @override
  Widget build(BuildContext context) {
    // final OrderItem todo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        leading: RaisedButton(
          color: Colors.indigo[900],
          padding: EdgeInsets.only(right: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {},
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            color: Colors.white,
            iconSize: 60,
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        title: const Text(
          'Product Card',
          style: TextStyle(fontSize: 35),
        ),
        centerTitle: true,
        elevation: 10,
        toolbarHeight: 100,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        bottomOpacity: 20,
        backgroundColor: Colors.teal[400],
      ),
      body: Stack(
        children: <Widget>[        
          Padding(
            padding: const EdgeInsets.all(50),
            child: Card(
              elevation: 10,
              color: Colors.green.shade200.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(
                  color: Colors.green.withOpacity(0.5),
                  width: 3,
                  style: BorderStyle.solid,
                ),
              ),
              child: FutureBuilder<List<SngProducts>>(
                  future: _albums,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<SngProducts> data = snapshot.data;
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white.withOpacity(0.7),
                              elevation: 10,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'assets/rbn.png',
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Style Name:   ${snapshot.data[0].id.toString()}',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                          Text(
                                            'Description:   ${snapshot.data[0].styleCode.toString()}',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                          Text(
                                            'Stock Balance: ', //  ${snapshot.data[0].variants[0]['size'].toString()}',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 28),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                             // color: Colors.white.withOpacity(0.7),
                              elevation: 10,
                              child:Column(
                                children: [
                            Container(
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(12.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Code",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "QTY",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Price",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                height: 300,
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 300,
                                        color: Colors.white,
                                        child: Center(
                                          child: getItemData(
                                              snapshot.data[index].variants),
                                        ),
                                      );
                                    })),
                              ],),),
                            
                          ]);
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
                                    color: Colors.white, fontSize: 20)),
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
        ],
      ),
    );
  }
}
