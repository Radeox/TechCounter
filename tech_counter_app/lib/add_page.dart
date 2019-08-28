import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddPage extends StatelessWidget {
  // States of various widgets
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _webpageKey = GlobalKey<FormState>();
  final _techKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Collect all the data from input
    Map userInput = {
      'name': null,
      'url': null,
      'regex': null,
    };

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: <Widget>[
            // Webpage form
            Form(
              key: _webpageKey,
              child: Column(
                children: <Widget>[
                  // Title
                  Text(
                    "New Webpage",
                    style: TextStyle(fontSize: 30),
                  ),

                  // Webpage name input
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Webpage name',
                    ),
                    textAlign: TextAlign.center,

                    // Validator
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Empty field';
                      else
                        return null;
                    },

                    // On save function - triggered by the button
                    onSaved: (value) => userInput['name'] = value,
                  ),

                  // Webpage URL input
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Webpage URL',
                    ),
                    textAlign: TextAlign.center,

                    // Validator
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Empty field';
                      else
                        return null;
                    },

                    // On save function - triggered by the button
                    onSaved: (value) => userInput['url'] = value,
                  ),

                  // Submit button
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () => checkAndSend(
                      _webpageKey,
                      userInput,
                      "http://51.158.173.57:9000/api/v1/webpage/",
                    ),
                  ),
                ],
              ),
            ),

            // Technology form
            Form(
              key: _techKey,
              child: Column(
                children: <Widget>[
                  // Title
                  Text(
                    "New technology",
                    style: TextStyle(fontSize: 30),
                  ),

                  // Tech name input
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Technology name',
                    ),
                    textAlign: TextAlign.center,

                    // Validator
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Empty field';
                      else
                        return null;
                    },

                    // On save function - triggered by the button
                    onSaved: (value) => userInput['name'] = value,
                  ),

                  // Regex input
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Regular expression',
                    ),
                    textAlign: TextAlign.center,

                    // Validator
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Empty field';
                      else
                        return null;
                    },

                    // On save function - triggered by the button
                    onSaved: (value) => userInput['regex'] = value,
                  ),

                  // Submit button
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () => checkAndSend(
                      _techKey,
                      userInput,
                      "http://51.158.173.57:9000/api/v1/tech/",
                    ),
                  ),
                ],
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }

  void checkAndSend(
      GlobalKey<FormState> formKey, Map userInput, String url) async {
    // If inputs are not empty
    if (!formKey.currentState.validate()) {
      // Toast notification - missing data
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.red,
          content: new Text("Please, fill all the fields."),
        ),
      );
    } else {
      // Toast notification - sending data
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.white24,
          content: new Text("Data sent to server."),
        ),
      );

      // Trigger save function of the form
      formKey.currentState.save();

      // Make the URL
      Response response;

      // Send the request
      try {
        response = await post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": userInput['name'],
            "url": userInput['url'],
            "regex": userInput['regex']
          }),
        );
      } on SocketException {}

      if (response.body == "") {
        // Toast notification - data added to server
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.green,
            content: new Text("Data added to database."),
          ),
        );
      } else {
        // Toast notification - error from server
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.red,
            content: new Text("Server error."),
          ),
        );
      }
    }
  }
}
