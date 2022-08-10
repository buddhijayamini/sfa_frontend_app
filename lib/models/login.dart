//  Future userLogin() async {
//     // Showing CircularProgressIndicator.
//     setState(() {
//       visible = true;
//     });

//   // Getting value from Controller
//   String email = emailController.text;
//   String password = passwordController.text;
//   String db = dbController.text;

//   //SERVER LOGIN API URL
//   var url = "$baseURL/auth/get_tokens";
//   var data = {
//     //  'us_code':us_code,
//     'username':email,//'admin@codeso.lk',
//     'password':password,//'Q8Yv4nSH',
//     'db':db,//'stafford.codeso.lk',
//   };

// final userdata =  Map<String, dynamic>.from(data);

//  await http.post(
//     Uri.parse(url),
//     headers: {
//       'Accept': 'application/json'
//     }, 
//     body:userdata,// json.encode(data)
//   ).then((response) {
//   // log("resp- $response");
//   var message = jsonDecode(response.body);
//   log("msg- $message");

//   if (response.statusCode == 200){
//     setState(() {
//       visible = false;
//     });
//   Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>  Root(userdata:userdata.toString())
//         ));
//   } else {
//     setState(() {
//       visible = false;
//     });
//      if(userdata.containsKey("message")) {
//           showDialog(context: context, builder: (BuildContext context) =>
//             getAlertDialog("Login failed", '${userdata["message"]}', context));
//         }
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//         title:  Text(message),
//           actions: <Widget>[
//             // ignore: deprecated_member_use
//             FlatButton(
//               child: const Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } 
//   }).catchError((err) {
//       showDialog(context: context, builder: (BuildContext context) =>
//         getAlertDialog("Login failed as", err.toString(), context));
//     });
//   }
