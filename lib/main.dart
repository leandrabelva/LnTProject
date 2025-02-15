import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int stepsToday = 0;
  double waterToday = 0.0;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stepsToday = prefs.getInt(today + '_steps') ?? 0;
      waterToday = prefs.getDouble(today + '_water') ?? 0.0;
    });
  }

  String _getStepCategory(int steps) {
    if (steps < 4000) return "Bad";
    if (steps <= 8000) return "Average";
    return "Good";
  }

  String _getWaterCategory(double water) {
    if (water < 1.5) return "Bad";
    if (water <= 2.0) return "Average";
    return "Good";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fitness Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Today's Summary (${today})",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.directions_walk, color: Colors.red),
                title: Text("Steps"),
                subtitle: Text("$stepsToday - ${_getStepCategory(stepsToday)}"),
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.local_drink, color: Colors.blueAccent),
                title: Text("Water Intake"),
                subtitle: Text(
                  "$waterToday L - ${_getWaterCategory(waterToday)}",
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepsTrackerScreen()),
                ).then((_) => _loadData());
              },
              icon: Icon(Icons.directions_walk),
              label: Text("Steps Tracker", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaterIntakeScreen()),
                ).then((_) => _loadData());
              },
              icon: Icon(Icons.local_drink),
              label: Text("Water Intake", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class StepsTrackerScreen extends StatefulWidget {
  @override
  _StepsTrackerScreenState createState() => _StepsTrackerScreenState();
}

class _StepsTrackerScreenState extends State<StepsTrackerScreen> {
  int steps = 0;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      steps = prefs.getInt(today + '_steps') ?? 0;
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(today + '_steps', steps);
  }

  void _addSteps(int value) {
    setState(() {
      steps += value;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Steps Tracker - $today")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _addSteps(500),
            child: Text("Add 500 Steps"),
          ),
          Text("Total Steps: $steps"),
        ],
      ),
    );
  }
}

class WaterIntakeScreen extends StatefulWidget {
  @override
  _WaterIntakeScreenState createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  double water = 0.0;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      water = prefs.getDouble(today + '_water') ?? 0.0;
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(today + '_water', water);
  }

  void _addWater(double value) {
    setState(() {
      water += value;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Water Intake - $today")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _addWater(0.5),
            child: Text("Add 0.5L Water"),
          ),
          Text("Total Water Intake: $water L"),
        ],
      ),
    );
  }
}
