import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MaterialApp(
      theme: ThemeData.dark(),
      title: "Hospital Management",
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String state_id;
  String district_id;
  final String url = "https://cdn-api.co-vin.in/api/v2/admin/location/states";
  List district = [];
  List data = []; //edited line

  Future<String> getDistrict() async {
    String url = "https://cdn-api.co-vin.in/api/v2/admin/location/districts/";
    if (state_id == null) return "Wait";
    url += state_id;
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    print(resBody);
    setState(() {
      district = resBody['districts'];
    });
    return "Sucess";
  }

  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody['states'];
    });
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Hospital Management"),
      ),
      body: Container(
        // color: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add your state and district',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'State : ',
                    style: TextStyle(color: Colors.white),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                ),
                DropdownButton(
                  items: data.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['state_name']),
                      value: item['state_id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      district_id = null;
                      state_id = newVal;
                    });
                    getDistrict();
                  },
                  value: state_id,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'District : ',
                    style: TextStyle(color: Colors.white),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                ),
                DropdownButton(
                  items: district.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['district_name']),
                      value: item['district_id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      district_id = newVal;
                    });
                  },
                  value: district_id,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
