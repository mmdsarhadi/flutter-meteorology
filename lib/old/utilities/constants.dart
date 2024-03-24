import 'package:flutter/material.dart';

const apikey = '7b016927577596b1d35b665b58f3e0fe';
const KLightColor = Colors.white;
const KMIdLightColor = Colors.white60;
const KDarkColor = Colors.white24;
const KTextFieldDecoration = InputDecoration(
    fillColor: KOverLayColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide.none,
    ),
    hintStyle: KtextFieldTextStyle,
    hintText: 'Enter City Name',
    prefixIcon: Icon(Icons.search));
const KOverLayColor = Colors.white10;

const KtextFieldTextStyle = TextStyle(fontSize: 16, color: KMIdLightColor);
const KLocationTExtStyle = TextStyle(fontSize: 20, color: KMIdLightColor);
const KTempTextStyle = TextStyle(
  fontSize: 80,
);
const KDeteailsTextStyle =
    TextStyle(fontSize: 20, color: KMIdLightColor, fontWeight: FontWeight.bold);
const KDeteailsTitleTextStyle = TextStyle(
  fontSize: 16,
  color: KDarkColor,
);
const KDeteailsSuffixTextStyle = TextStyle(
 fontSize: 12,
  color: KMIdLightColor
);
