import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meteorology/utilities/constants.dart';
class Details_wedget extends StatelessWidget {
  final String title , value;
  const Details_wedget({
    super.key, required this.title, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: KDeteailsTextStyle,
            ),       Visibility(
              visible: title=="WIND"?true:false,
              child: Text(
                ' km/hr',
                style: KDeteailsSuffixTextStyle,
              ),
            ),
          ],
        ),
        Text(
          title,
          style: KDeteailsTitleTextStyle,
        )
      ],
    );
  }
}