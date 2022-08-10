import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:sfa_frontend_app/models/box_load.dart';
import 'package:sfa_frontend_app/models/single_prd.dart';
import 'package:sfa_frontend_app/screens/login.dart';
import 'package:sfa_frontend_app/subScreens/call_lost.dart';
import 'package:sfa_frontend_app/subScreens/product_add.dart';
import 'package:sfa_frontend_app/subScreens/add_cart.dart';
import 'package:flutter/foundation.dart';

class ProductView extends StatefulWidget {
  final String userdata;
  int prdId;
  ProductView({key, this.prdId, this.userdata}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  TextEditingController boxQty = new TextEditingController();
  TextEditingController pcQty = new TextEditingController();

  final List<String> imgList = [
    'assets/TS_01.jpg',
    'assets/TS_02.jpg',
    'assets/TS_03.jpg',
    'assets/TS_04.png',
    // 'https://staffordgarments.com/wp-content/uploads/2018/06/DPP_0246.jpg',
    // 'https://staffordgarments.com/wp-content/uploads/2018/06/Slider-Image-4.jpg',
    // 'https://staffordgarments.com/wp-content/uploads/2018/06/IMG_5590.jpg',
    // 'https://staffordgarments.com/wp-content/uploads/2018/06/Slider-3.png',
  ];
  int _currentIndex = 0;
  final List<String> titles = [
    'Cassual 1',
    'Sport 1',
    'Sport 2',
    'Cassual 2',
  ];

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
//print(jsonResponse[0]);
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

  Future<List<SngProducts>> _albums;

  final controller = ScrollController();
  double offset = 0;
  final _formKey = GlobalKey<FormState>();

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

  _save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/save_prd_data.txt');
    var varint = getItemData;
    int prdId1 = widget.prdId;

    // List<String> dataList = [];
    // dataList = [
    //  prdId2 = prdId1,
    //varint =getItemData(
    // snapshot.data[index].variants),
    // SngProducts().variants.toString(), //.indexOf("price").toString(),
    // size = SngProducts().variants.toString().indexOf("size").toString(),
    // box = boxQty.text,
    // piecs = pcQty.text,
    //];

    await file.writeAsString(
        "id:" + prdId1.toString() + '\n' + "varint:" + varint.toString());
    // dataList.toString());
    print('saved');
  }

  ListView getItemData(data) {
    List list = <Widget>[];
    //   var prdSize = items.size.toString();
    // double prdQty = items.avlQty;
    // double boxQtys = double.parse(sna[0].strctQty);
    // var boxSize = data1[0].strctName.toString();
    // var boxName = data1[0].boxName.toString();
    // double allBox = 0;
    // double allPiecs = 0;

    for (var item in data) {
      list.add(Row(
        children: [
          Container(
              //   margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Text('${item[4]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Container(
            // margin: EdgeInsets.all(12.0),
            padding: EdgeInsets.only(left: 20, right: 30),
            child: Text('${item[2]}',
                style: TextStyle(color: Colors.blue, fontSize: 24)),
          ),
          Container(
              // margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Text('${item[3]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Container(
              // margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Text('${item[3]}',
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Container(
            width: 100,
            //  margin: EdgeInsets.all(12.0),
            padding: EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: pcQty,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: 'Bx.QTY'),
            ),
          ),
          Container(
            width: 100,
            // margin: EdgeInsets.all(12.0),
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: boxQty,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: 'Pc.QTY'),
            ),
          ),
        ],
      ));
    }

    return ListView(
        padding: const EdgeInsets.only(left: 10, right: 10), children: list);
  }

  @override
  Widget build(BuildContext context) {
    // final OrderItem todo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //ignore: deprecated_member_use
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.indigo[900],
          iconSize: 60,
          onPressed: () {
            // Scaffold.of(context).hasDrawer;
          },
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
        actions: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            padding: EdgeInsets.only(right: 5, left: 5),
            color: Colors.indigo[900],
            shape: CircleBorder(),
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.white,
              iconSize: 50,
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            padding: EdgeInsets.only(right: 5, left: 5),
            color: Colors.indigo[900],
            shape: CircleBorder(),
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              iconSize: 50,
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<List<SngProducts>>(
          future: _albums, //Future.wait([_albums, _box]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //  List<SngProducts> data = snapshot.data; //[0].variants;
              // print(snapshot.data[0].variants);
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 100, top: 50),
                    child: Text(
                      snapshot.data[0].styleCode,
                      textScaleFactor: 2.0,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 50, right: 50, bottom: 50),
                    child: Card(
                      elevation: 10,
                      color: Colors.green.shade200.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: Colors.green.withOpacity(0.2),
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(
                                  () {
                                    _currentIndex = index;
                                  },
                                );
                              },
                            ),
                            items: imgList
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      margin: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      elevation: 6.0,
                                      shadowColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Image.asset(
                                              item,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 410,
                                            ),
                                            Center(
                                              child: Text(
                                                titles[_currentIndex],
                                                style: const TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                  backgroundColor:
                                                      Colors.black45,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Price",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Size",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Avl. Box",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Avl. Pieces",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ord. Box",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ord. Pieces",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    //padding: EdgeInsets.only(left: 10, right: 10),
                                    height: 260,
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: 260,
                                            color: Colors.white,
                                            child: Center(
                                              child: getItemData(snapshot
                                                  .data[index].variants),
                                            ),
                                          );
                                        })),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              ButtonBar(children: <Widget>[
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  color: Colors.teal[500],
                                  onPressed: () {
                                    _save();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddCart(
                                          userdata: widget.userdata,
                                          prdId: snapshot.data[0].id,
                                          varient: getItemData(
                                              snapshot.data[0].variants),
                                        ),
                                      ),
                                    );
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         backgroundColor:
                                    //             Colors.white.withOpacity(0.8),
                                    //         title: const Text("View Cart",
                                    //             style: TextStyle(
                                    //                 color: Colors.deepPurple,
                                    //                 fontSize: 25)),
                                    // content:  AddCart(
                                    //           userdata: widget.userdata,
                                    //           prdId: snapshot.data[0].id,
                                    //           varient: getItemData(snapshot.data[0].variants),
                                    //         ),
                                    // actions: <Widget>[
                                    //   // ignore: deprecated_member_use
                                    //   FlatButton(
                                    //     color: Colors.redAccent,
                                    //     child: const Text("Close",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 20)),
                                    //     onPressed: () {
                                    //       Navigator.of(context).pop();
                                    //     },
                                    //   ),
                                    // ],
                                    // );
                                    // }
                                    // );
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("Add to Cart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))),
                                ),
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    /* */
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
