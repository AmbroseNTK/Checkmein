import 'package:flutter/material.dart';

abstract class PolyState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1200) {
      return buildXL(context);
    } else if (MediaQuery.of(context).size.width >= 992) {
      return buildL(context);
    } else if (MediaQuery.of(context).size.width >= 768) {
      return buildM(context);
    } else if (MediaQuery.of(context).size.width >= 576) {
      return buildS(context);
    } else {
      return buildXS(context);
    }
  }

  Widget buildXS(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildS(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildM(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildL(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildXL(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildDefault(BuildContext context);
}
