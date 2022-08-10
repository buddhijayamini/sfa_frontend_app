import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({key,  this.email}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 @override
    Widget build(BuildContext context) {
           
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.red,
          ),
  
              body: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(13.0),
                    color: Colors.redAccent,
                    child: const Text("home"),
                )
              )                          
        );
    }
}
  
