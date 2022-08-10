import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sfa_frontend_app/main.dart';
import 'package:sfa_frontend_app/screens/config.dart';

class LoginUser extends StatefulWidget {
 //final List serverData;
   LoginUser({key}) : super(key: key);

  @override
  LoginUserState createState() => LoginUserState();
}

Future _read() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sfa_server_data.txt');
    String serverData1 = await file.readAsString();
   // print(serverData);//.indexOf('db').toString());
  } catch (e) {
    print("Couldn't read file");
  }
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;
  final _formKey = GlobalKey<FormState>();

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dbController = TextEditingController();

  AlertDialog getAlertDialog(title, content, context) {
    return AlertDialog(
      title: const Text("Login failed"),
      content: Text('$content'),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = 'admin@codeso.lk';
    //'admin@codeso.lk'; //'abc@gmail.com'; // emailController.text;
    String password = 'Q9Yv4nSH';
    //'Q9Yv4nSH'; //'abc1234'; //passwordController.text;
    String db = serverDB;

    //SERVER LOGIN API URL
    var url = "$baseURL/auth/get_tokens";
    var data = {
      'username': email,
      'password': password,
      'db': db,
    };

    final userdata = Map<String, dynamic>.from(data);

    await http
        .post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/x-www-form-urlencoded',
        'charset': 'utf-8'
      },
      body: userdata,
    )
        .then((response) {
      var result = response.body;

      if (response.statusCode == 200) {
        setState(() {
          visible = false;
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(userdata: result),
            ));
      } else {
        setState(() {
          visible = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0.8),
                title: const Text("Error....",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 25)),
                content: const Text("Wrong User Details to load",
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
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              getAlertDialog("Login failed as", err.toString(), context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
         padding:  EdgeInsets.only(left: 10,top:50),
          color: Colors.teal[500],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // ignore: deprecated_member_use
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  color: Colors.indigo[900],
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    iconSize: 40,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfigScreen(),
                          ));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
             
               Center(
                  child: Form(
                key: _formKey,
                  child: Card(
                    color: Colors.white.withOpacity(0.4),
                    shadowColor: Colors.teal[400],
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    // ignore: avoid_unnecessary_containers
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                        //  margin: EdgeInsets.only(left: 50, right: 50),
                          width: MediaQuery.of(context).size.width / 2,
                         // padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: true,
                            initialValue:
                                'admin@codeso.lk', // 'buddhi@codeso.lk',
                            // controller: emailController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter User Name';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 30, color: Colors.blue),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Your Email',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.indigo,
                                  size: 50,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 50, right: 50),
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            initialValue: 'Q9Yv4nSH', //'@123456789',
                            // controller: passwordController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 30, color: Colors.blue),
                            autocorrect: true,
                            obscureText: true,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Your Password',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.indigo,
                                  size: 50,
                                )),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          margin: const EdgeInsets.only(top: 20.0),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            elevation: 10,
                            padding: EdgeInsets.all(20),
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.login_outlined,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                userLogin();
                              }
                            },
                            color: Colors.indigo[900],
                          ),
                        ),
                        Visibility(
                          visible: visible,
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.teal[500],
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
        child: Text(
          ' Powered By Buddhi Soft Solutions ',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
            wordSpacing: 10,
            backgroundColor: Colors.teal[500],
          ),
        ),
      ),
    );
  }
}
