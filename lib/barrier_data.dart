import 'package:flutter/material.dart';

class BarierData {
  static List<Map<String, double>> data = [
    // max(sum(top + bottom)) == 0.6
    {'top': 0.5, 'bottom': 0.1},
    {'top': 0.1, 'bottom': 0.5},
    {'top': 0.3, 'bottom': 0.3},
    {'top': 0.2, 'bottom': 0.4},
    {'top': 0.4, 'bottom': 0.2},
    {'top': 0.25, 'bottom': 0.35},
    {'top': 0.05, 'bottom': 0.55},
    {'top': 0.15, 'bottom': 0.45},
    {'top': 0.45, 'bottom': 0.15},
  ];
}

class PairBarier extends StatelessWidget {
  final Map<String, double> data;

  const PairBarier(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = const BorderSide(color: Colors.black, width: 2);

    double screenHeight = MediaQuery.of(context).size.height;

    double width = 85; // fixed width
    double topHeight = screenHeight * data['top']!;
    double bottomHeight = screenHeight * data['bottom']!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: width,
          height: topHeight,
          decoration: BoxDecoration(
              color: Colors.green,
              border: Border(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
              )),
        ),
        Container(
          width: width,
          height: bottomHeight,
          decoration: BoxDecoration(
              color: Colors.green,
              border: Border(
                top: borderSide,
                left: borderSide,
                right: borderSide,
              )),
        )
      ],
    );
  }
}
