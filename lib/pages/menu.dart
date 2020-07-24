import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colorPrimary,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 5.0, 0),
          child: Image.asset('assets/images/checkmein.png', width: 25.0),
        ),
        title: Text(
          'Checkmein',
          style: R.textHeadingWhite,
        ),
      ),
      body: buildMenu(context),
      backgroundColor: R.colorPrimary,
    );
  }

  Widget buildMenu(BuildContext context) {
    Container container1 = Container(
      constraints: BoxConstraints(minWidth: 250),
      width: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
      // height: MediaQuery.of(context).size.height * 0.2,
      child: FloatingActionButton.extended(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/event.png',
          width: 25.0,
          height: 25.0,
        ),
        label: Text(
          'Create event',
          style: R.textTitleL,
        ),
        tooltip: "Create Your Event",
      ),
    );
    Container container2 = Container(
      constraints: BoxConstraints(minWidth: 270),
      width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.width * 0.2,
      child: FloatingActionButton.extended(
        label: Text(
          'View Attendee',
          style: R.textTitleL,
        ),
        onPressed: () {},
        icon: Image.asset(
          'assets/images/view.png',
          width: 25.0,
          height: 25.0,
        ),
        tooltip: "View Attendee",
      ),
    );
    if (MediaQuery.of(context).size.width > 768) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [container1, container2],
          )
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [container1],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [container2],
        )
      ],
    );
  }
}
