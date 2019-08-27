import 'package:flutter/material.dart';
import 'package:tech_counter_app/tech_page.dart';
import 'package:tech_counter_app/web_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechCounter',
      theme: ThemeData(
          // Dark mode
          brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Index selected by the user
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    WebPage(),
    TechPage(),
    Text('Index 2: School'),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechCounter"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Bottom bar buttons
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            title: Text('Websites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Technologies'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('Add new'),
          ),
        ],

        // Selected index
        currentIndex: _selectedIndex,

        // Selected color
        selectedItemColor: Colors.amber[800],

        // Function called when users tap a button
        onTap: _onItemTapped,
      ),
    );
  }
}
