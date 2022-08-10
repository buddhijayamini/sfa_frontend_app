import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/admin/all_routes.dart';
import 'package:sfa_frontend_app/admin/all_summery.dart';

class AdminScreen extends StatefulWidget {
  final String userdata;
  const AdminScreen({key, this.userdata}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              child: Container(
                child: Column(children: [
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 300,
                    width: 500,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        color: Colors.indigo[900],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllExecutiveSummery(
                                    userdata: widget.userdata)),
                          );
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.account_balance_rounded,
                            size: 100,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Exceutive Summery',
                            style: TextStyle(fontSize: 35, color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 300,
                    width: 500,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        color: Colors.indigo[900],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllRouteLists(userdata: widget.userdata)),
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.line_style_outlined,
                              size: 100, color: Colors.white),
                          title: Text(
                            'All Routes',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
              )),
        ),
      ),
    );
  }
}
