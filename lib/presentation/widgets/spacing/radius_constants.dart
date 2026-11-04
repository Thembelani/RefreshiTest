import 'package:flutter/material.dart';

const double _small = 6;
const double _medium = 12;
const double _large = 18;
const double _extraLarge = 24;

// Radius
final radiusSmall = Radius.circular(_small);

final radiusMedium = Radius.circular(_medium);

final radiusLarge = Radius.circular(_large);

final radiusExtraLarge = Radius.circular(_extraLarge);

// BorderRadius
final borderRadiusSmall = BorderRadius.circular(_small);

final borderRadiusMedium = BorderRadius.circular(_medium);

final borderRadiusLarge = BorderRadius.circular(_large);

final borderRadiusExtraLarge = BorderRadius.circular(_extraLarge);

// Misc
final textFieldRadius = OutlineInputBorder(
  borderRadius: borderRadiusMedium,
);

final elevatedButtonRadius = RoundedRectangleBorder(
  borderRadius: borderRadiusMedium,
);
