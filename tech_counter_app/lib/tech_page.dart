import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TechPage extends StatelessWidget {
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
    Map store = {};

    // Create an empty list
    List<Widget> list = List();

    // Make the url with the arguments from the previous screen
    String url = 'http://51.158.173.57:9000/api/v1/webpage/?limit=0';

    // Send the request
    Response response = await get(url);

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
      // Loop through the fields of each object
      for (String field in obj.keys) {
        // Add name as title of the tile
        if (field == "technologies") {
          // Count technologies
          for (String tech in obj[field]) {
            // Make the URL
            String url = 'http://51.158.173.57:9000' + tech;

            // Check if tech was already counted once
            if (store[url] == null)
              store[url] = 1;
              else
              store[url]++;
          }
        }
      }
    }

      for(String url in store.keys) {
        String name;
              // Send the request
              Response response = await get(url);

              try {
                result = json.decode(response.body);
              } on Exception {}

              // Get the name and store it to avoid many requests
              name = result['name'];

      // Ceate the tile and add it
      list.add(Card(
        child: ListTile(
          title: Text(name),
          subtitle: Text(store[url].toString()),
          // subtitle: Text(subtext),
        ),
      ));

      }

    return list;
  }
}
