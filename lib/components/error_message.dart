import 'package:flutter/material.dart';
import 'package:meteorology/utilities/constants.dart';

class ErrorMessage extends StatelessWidget {
  final String title, message;

  const ErrorMessage({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_rounded, size: 150,),
            SizedBox(
              height: 20,
            ),
            Text(title, style: KDeteailsTextStyle,),
            SizedBox(
              height: 8,
            ),
            Text(message, style: KLocationTExtStyle, textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
