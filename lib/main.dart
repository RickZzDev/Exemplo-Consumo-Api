import 'dart:convert';

import 'package:api_exemplo/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UsersResponse newUsers;

  Future getUsers() async {
    try {
      final url = "https://jsonplaceholder.typicode.com/users";
      http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception();
      }
      final jsonResponse = json.decode(response.body);
      newUsers = UsersResponse().fromJSON(jsonResponse);
    } catch (e) {
      Exception(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Flexible(
                      child: ListView.builder(
                          itemCount: newUsers.users.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "Nome: ${newUsers.users[index].name}"),
                                        Text(
                                            "Email: ${newUsers.users[index].email}")
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                            );
                          }),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
      //This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
