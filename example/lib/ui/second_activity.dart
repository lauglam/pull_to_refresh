import 'package:flutter/material.dart';

class SecondActivity extends StatefulWidget {
  const SecondActivity({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SecondActivity> createState() => _SecondActivityState();
}

class _SecondActivityState extends State<SecondActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: GestureDetector(
            child: Row(
              children: const [Icon(Icons.keyboard_arrow_left), Text("返回")],
            ),
            onTap: () {
              Navigator.of(context).pop();
            }),
      ),
      body: const Text("测试跳转返回"),
    );
  }
}
