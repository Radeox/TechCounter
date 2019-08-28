import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of widgets that will be constructed by getList()
    Future<List<Widget>> results = getList();

    return FutureBuilder(
      future: results,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        // If still have no data display loading indicator
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Get the received data
          List content = snapshot.data;

          // Create and return the list
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(children: content),
              ),
            ],
          );
        }
      },
    );
  }

  Future<List<Widget>> getList() async {
    // Result of the request to API
    Map result = {};
    Map names = await _getTechnologies();
    Response response;

    // Create an empty list
    List<Widget> list = List();

    // Make the url with the arguments from the previous screen
    String url = 'http://51.158.173.57:9000/api/v1/webpage/?limit=0';

    // Send the request
    try {
      response = await get(url);
    } on SocketException {
      list.add(
        Card(
          child: ListTile(
            title: Text("Network error"),
            subtitle: Text("Can't connect to server."),
          ),
        ),
      );

      return list;
    }

    // Try decoding results
    // If they are empty the result will not be a JSON
    try {
      result = json.decode(response.body);
    } on Exception {}

    // If no results (network/request error) or the
    //results are empty (closing day) then return the empty list
    if ((result.isEmpty) || (result['objects'].isEmpty)) return list;

    // Loop through the json reponse
    for (Map obj in result['objects']) {
      String text = "";
      String subtext = "";

      // Loop through the fields of each object
      for (String field in obj.keys) {
        // Add name as title of the tile
        if (field == "name")
          text += obj[field].toString() + "\n";
        // Add all the tecnologies as subtitle of the tile
        else if (field == "technologies") {
          // Convert each tech URL into his name
          for (String tech in obj[field]) {
            // Recovered name
            String name;

            // Make the URL
            String url = 'http://51.158.173.57:9000' + tech;

            // Check if the name was already loaded
            if (names[url] == null) {
              // Send the request
              response = await get(url);

              try {
                result = json.decode(response.body);
              } on Exception {}

              // Get the name and store it to avoid many requests
              name = result['name'];
              names[url] = name;
            } else {
              // Retrive the stored name
              name = names[url];
            }

            // Add the name to the list
            subtext += "· " + name + "\n";
          }
        }
      }

      // Ceate the tile and add it
      list.add(
        Card(
          child: ListTile(
            title: Text(text),
            subtitle: Text(subtext),
          ),
        ),
      );
    }

    // Save the names for next runs
    _setTechnologies(names);

    return list;
  }

  // Save the technologies names for faster loadings
  _setTechnologies(Map technologies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String techEncoded = json.encode(technologies);

    await prefs.setString('technologies', techEncoded);
  }

  // Load the technologies names
  _getTechnologies() async {
    Map technologies = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String techEncoded = prefs.getString('technologies');

    if (techEncoded != null) technologies = json.decode(techEncoded);

    return technologies;
  }
}
