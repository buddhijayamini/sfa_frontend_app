import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sfa_frontend_app/screens/sales_inquery.dart';
import 'package:sfa_frontend_app/subScreens/all_routes.dart';
import 'package:sfa_frontend_app/subScreens/product_list.dart';
import 'package:sfa_frontend_app/subScreens/executive_summery.dart';

class InquiryScreen extends StatefulWidget {
  final String userdata;
  const InquiryScreen({key,  this.userdata}) : super(key: key);

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inquiry",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
         toolbarHeight: 100,
        backgroundColor: Colors.teal[500],
      ),
      body: Center(
        // ignore: avoid_unnecessary_containers
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
         padding: const EdgeInsets.all(20),
          color: Colors.teal[300],
          child: Card(
            color: Colors.white,
            shadowColor: Colors.teal[300],
            child: Container(
              color: Colors.white,
             width: double.infinity,
             height: double.infinity,
              child: Column(
                children: [    
                    const  SizedBox(
                                height: 80,
                              ),             
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 6.0,
                        margin: const EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.tealAccent,
                            style: BorderStyle.solid,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                         
                              // ignore: deprecated_member_use
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SalesInquiry(userdata: widget.userdata)),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/rbn.png',
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height:MediaQuery.of(context).size.height/4,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Sale Orders',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 6.0,
                        margin: const EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.tealAccent,
                            style: BorderStyle.solid,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              // ignore: deprecated_member_use
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductList(userdata: widget.userdata)),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/rbn2.png',
                                  width:MediaQuery.of(context).size.width / 4,
                                    height:MediaQuery.of(context).size.height/4,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Price & Stock',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 6.0,
                        margin: const EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.tealAccent,
                            style: BorderStyle.solid,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              // ignore: deprecated_member_use
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllRoute(userdata: widget.userdata)),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/rbn2.png',
                                  width:MediaQuery.of(context).size.width / 4,
                                    height:MediaQuery.of(context).size.height/4,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Route Plan',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 6.0,
                        margin: const EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.tealAccent,
                            style: BorderStyle.solid,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              // ignore: deprecated_member_use
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExecutiveSummery(userdata: widget.userdata)),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/rbn.png',
                                   width:MediaQuery.of(context).size.width/4,
                                    height:MediaQuery.of(context).size.height/4,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Execute Summery',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
