import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meteorology/utilities/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPulse(
              color: KLightColor,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Fetching data...",
              style: TextStyle(fontSize: 20, color: KMIdLightColor),
            )
          ],
        ),
      ),
    );
  }
}
