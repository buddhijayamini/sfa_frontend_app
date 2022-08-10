import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sfa_frontend_app/screens/login.dart';

class ConfigScreen extends StatefulWidget {
  ConfigScreen({key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

final dbController = TextEditingController();
final serverController = TextEditingController();

String baseURL = "https://stafford.codeso.lk/api";//serverController.text;
String serverDB = "stafford.codeso.lk";// dbController.text;

Future _save() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/sfa_server_data.txt');
  final server =  serverController.text;
  final dbs =  dbController.text;
  await file.writeAsString("baseUrl:" + server + ',\n' + "db:" + dbs);
   print('saved');
}

class _ConfigScreenState extends State<ConfigScreen> {

    final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(100),
          color: Colors.teal[500],
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Form(
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
                        // SizedBox(
                        //   height: 50,
                        // ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            // initialValue: 'https://stafford.codeso.lk/api',
                            controller: serverController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Server URL';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                            autocorrect: true,
                            decoration: const InputDecoration(
                                hintText:
                                    'Your Server URL - https://stafford.codeso.lk/api',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: Icon(
                                  Icons.web,
                                  color: Colors.indigo,
                                  size: 50,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            //initialValue: 'stafford.codeso.lk',
                            controller: dbController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter DB Name';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 30, color: Colors.white),
                            autocorrect: true,
                            decoration: const InputDecoration(
                                hintText: 'Your DB URL - stafford.codeso.lk',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: Icon(
                                  Icons.data_usage,
                                  color: Colors.indigo,
                                  size: 50,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          margin: const EdgeInsets.only(top: 20.0),
                          child: ButtonBar(
                            buttonPadding: EdgeInsets.only(right: 50),
                            children: [
                              // ignore: deprecated_member_use
                              RaisedButton(
                                elevation: 10,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginUser(),
                                          ));
                                },
                                color: Colors.redAccent,
                              ),
                              // ignore: deprecated_member_use
                              RaisedButton(
                                elevation: 10,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {
                                   if (_formKey.currentState.validate()) {
                                      _save();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginUser(),
                                          ));
                                   }
                                },
                                color: Colors.indigo[900],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                      ]),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
