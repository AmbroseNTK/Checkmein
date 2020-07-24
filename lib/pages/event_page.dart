import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: R.textHeadingWhite,
        ),
        backgroundColor: R.colorPrimary,
        elevation: 12,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/event.png', width: 25.0),
        ),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.green,
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.blue,
                  child: ListView(
                    children: [
                      for (int i = 0; i < 50; i++)
                        ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              child: Text('$i'),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
