import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/screens/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa_frontend_app/widget/admin_drawer_widget.dart';
import 'package:sfa_frontend_app/bloc/nav_drawer_bloc.dart';
import 'package:sfa_frontend_app/bloc/nav_drawer_state.dart';
import 'package:sfa_frontend_app/widget/drawer_widget.dart';
import 'package:sfa_frontend_app/screens/login.dart';

import 'package:sfa_frontend_app/screens/daily_routes.dart';
import 'package:sfa_frontend_app/screens/sales_inquery.dart';
import 'package:sfa_frontend_app/screens/admin.dart';
import 'package:sfa_frontend_app/subScreens/product_list.dart';
import 'package:sfa_frontend_app/subScreens/executive_summery.dart';
import 'package:sfa_frontend_app/subScreens/all_routes.dart';

void main() {
  runApp(MyApp());
}

// class ColorConstants {
//   static const kPrimaryColor = Color(0xFFF00796B);
//   }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA App',
      theme: ThemeData(
          primarySwatch:Colors.teal,// ColorConstants.kPrimaryColor, 
          scaffoldBackgroundColor: Colors.white
          ),
      home: LoginUser(),
    );
    ;
  }
}

class MyHomePage extends StatefulWidget {
  String userdata;
  MyHomePage({key, this.userdata}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NavDrawerBloc _bloc;
  Widget _content;

  Future doUserLogout() async {
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

  @override
  void initState() {
    super.initState();
    _bloc = NavDrawerBloc();
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => _bloc,
      child: BlocListener<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          setState(() {
            _content = _getContentForState(state.selectedItem);
          });
        },
        child: BlocBuilder<NavDrawerBloc, NavDrawerState>(
          builder: (BuildContext context, NavDrawerState state) => Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: Container(
                width: 550,
                // ignore: unrelated_type_equality_checks
                child: (jsonDecode(widget.userdata)['uid'] != 1)
                    ? NavDrawerWidget("SFA App",
                        'user id- ${jsonDecode(widget.userdata)['uid']}')
                    : AdminNavDrawerWidget("SFA App",
                        'user id- ${jsonDecode(widget.userdata)['uid']}')),
            appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.indigo[900],size: 150),
              title: Text(
                _getAppbarTitle(state.selectedItem),
                style: TextStyle(fontSize: 35),
              ),
              centerTitle: true,
              elevation: 10,
              toolbarHeight: 100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
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
              icon: Icon(Icons.logout),
              color: Colors.white,
              iconSize: 60,
              onPressed: () {
                logout();
              },
            ),
          ),
          ],
            ),
            body: AnimatedSwitcher(
              switchInCurve: Curves.easeInExpo,
              switchOutCurve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 300),
              child: _content,
            ),
          ),
        ),
      ));

  _getAppbarTitle(NavItem state) {
    switch (state) {
      case NavItem.homePage:
        return 'Daily Routes';
      case NavItem.salePage:
        return 'Sale Orders';
      case NavItem.prodList:
        return 'Price & Stock';
      case NavItem.routePlan:
        return 'Route Plan';
      case NavItem.exeSummery:
        return 'Executive Summery';
      case NavItem.adminPage:
        return 'Admin';
      default:
        return '';
    }
  }

  _getContentForState(NavItem state) {
    switch (state) {
      case NavItem.homePage:
        return SalesScreen(userdata: widget.userdata);
      case NavItem.salePage:
        return SalesInquiry(
          userdata: widget.userdata,
        );
      case NavItem.prodList:
        return ProductList(
          userdata: widget.userdata,
        );
      case NavItem.routePlan:
        return AllRoute(
          userdata: widget.userdata,
        );
      case NavItem.exeSummery:
        return ExecutiveSummery(
          userdata: widget.userdata,
        );
      case NavItem.adminPage:
        return AdminScreen(
          userdata: widget.userdata,
        );
      case NavItem.logout:
        return doUserLogout();
      default:
        return SalesScreen(
          userdata: widget.userdata,
        );
    }
  }
}
