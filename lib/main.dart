import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:DinnerConversations2/size_util.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinner Conversations',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Dinner Conversations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int iSampledQuestion = 0;
  List<List<dynamic>> _questionsAndPoints = [];

  @override
  void initState() {
    _setup();
    super.initState();
  }

  _setup() async {
    // Retrieve the questions (Processed in the background)
    List<List<dynamic>> questionsAndPoints = await _loadQuestions();

    // Notify the UI and display the questions
    setState(() {
      _questionsAndPoints = questionsAndPoints;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      if (_counter > _questionsAndPoints.length - 1) {
        _counter = 0;
      }
    });
  }

  void _easySamplingFromDiscreteDistribution() {
    setState(() {
      //sum the the absolute values of the points in the questionsAndPoints list

      T cast<T>(x) => x is T ? x : null;

      var pointsList = _questionsAndPoints
          .map((item) => cast<int>(item[1]))
          .toList(); //var givenList = _questionsAndPoints[:][1];

      print(pointsList.reduce(min));

      var absSumPoints =
          pointsList.reduce((value, element) => value.abs() + element.abs());

      //random number between 0 - sum(List). Randoms the question
      int randomNumber =
         Random().nextInt(absSumPoints+1);

      //Find question corresponding to random number by creating a distribution with the points
      int distributionPerQuestion = 0;

      for (int i = 0; i < pointsList.length; i++) {
        distributionPerQuestion = distributionPerQuestion + pointsList[i];
        if (randomNumber <= distributionPerQuestion) {
          iSampledQuestion = i;
          break;
        }
      }
    }); // setState
  } // _easySamplingFromDiscreteDistribution

  _loadQuestions() async {
    List<List<dynamic>> questionsAndPoints = [];
    final myData = await rootBundle.loadString('assets/QuestionsAndPoints.csv');
    questionsAndPoints = CsvToListConverter().convert(myData);
    return questionsAndPoints;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        //child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        //mainAxisAlignment: MainAxisAlignment.center,

        child: //<Widget>[

//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Padding(padding: EdgeInsets.only(top: SizeUtil.getPercentScreenHeight(
//                context, SizeUtil.FI()))),
            Container(
                width: SizeUtil.getPercentScreenWidth(context, SizeUtil.FI()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0.0, -SizeUtil.FI() / 2),
                      height: SizeUtil.getPercentScreenHeight(context, 0.2),
                      child: Text(
                        _questionsAndPoints[iSampledQuestion][0].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: (6 / 8) *
                                SizeUtil.getPercentScreenHeight(
                                    context, SizeUtil.FI() / 15)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: _easySamplingFromDiscreteDistribution,
                            child: Icon(Icons.thumb_up, color: Colors.green),
                          ),
                          FlatButton(
                            onPressed: _incrementCounter,
                            child: Icon(Icons.thumb_down, color: Colors.red),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                alignment: Alignment(0.0, -SizeUtil.FI() / 2)),

        //],
        //),
      ),

      //],
      //),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
