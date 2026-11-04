import 'dart:math';

import 'package:flutter/material.dart';

class CatalogItem {
  const CatalogItem({
    required this.id,
    required this.name,
    required this.priceCents,
    required this.icon,
  });

  final String id;
  final String name;
  final int priceCents;
  final IconData icon;

  String get priceLabel => formatRand(priceCents);
}

String formatRand(int priceCents) {
  final rands = priceCents ~/ 100;
  final cents = (priceCents % 100).toString().padLeft(2, '0');
  return 'R$rands.$cents';
}

const _productNames = <String>[
  'Berry Latte',
  'River Cream',
  'Spice Bite',
  'Frost Soda',
  'Golden Brew',
  'Spice Tart',
  'Ginger Slice',
  'Velvet Malt',
  'Orchard Tart',
  'Ruby Roast',
  'Cedar Pod',
  'River Roast',
  'Copper Draught',
  'Bright Pod',
  'Cocoa Slice',
  'Vanilla Fizz',
  'Honey Latte',
  'Ginger Drop',
  'Ruby Soda',
  'Cloudy Chai',
  'Sage Crisp',
  'Berry Smash',
  'Berry Bite',
  'Vanilla Soda',
  'Stone Pod',
  'Mint Brew',
  'Ginger Roll',
  'Mint Melt',
  'Meadow Fizz',
  'Storm Splash',
  'Cloudy Latte',
  'Summer Spritz',
  'Honey Malt',
  'Mint Roast',
  'Citrus Soda',
  'Citrus Spritz',
  'Vanilla Crisp',
  'Prairie Drop',
  'Garden Foam',
  'Peach Cooler',
  'Pearl Soda',
  'Storm Draught',
  'Pearl Drop',
  'Willow Roast',
  'Cedar Cider',
  'Summer Cream',
  'Valley Chai',
  'Stone Fizz',
  'Olive Tonic',
  'Velvet Foam',
  'Lemon Roast',
  'Valley Chip',
  'Berry Tonic',
  'Peach Draught',
  'Cedar Latte',
  'Coastal Brew',
  'Citrus Cider',
  'Quiet Spark',
  'Ginger Cream',
  'Olive Brew',
  'Olive Latte',
  'Olive Cooler',
  'Storm Melt',
  'Nectar Mist',
  'Golden Latte',
  'Nectar Fizz',
  'Willow Latte',
  'Solar Roast',
  'Sage Chip',
  'Honey Chai',
  'Timber Brew',
  'Ruby Cola',
  'Coastal Smash',
  'Ruby Slice',
  'Ruby Latte',
  'Timber Tonic',
  'Willow Fizz',
  'Summer Draught',
  'Copper Tonic',
  'Velvet Cola',
  'Velvet Cream',
  'Honey Chip',
  'Frost Chip',
  'Citrus Tart',
  'Harbor Roll',
  'Berry Chai',
  'Citrus Tonic',
  'Orchard Latte',
  'Storm Drop',
  'Pearl Bite',
  'Pearl Malt',
  'Willow Splash',
  'Harbor Cola',
  'Lemon Splash',
  'Willow Malt',
  'Summer Pod',
  'Copper Bite',
  'Pearl Cola',
  'Citrus Roast',
  'Cocoa Malt',
];

const _productIcons = <IconData>[
  Icons.coffee_outlined,
  Icons.emoji_food_beverage_outlined,
  Icons.blender_outlined,
  Icons.water_drop_outlined,
  Icons.local_drink_outlined,
  Icons.bakery_dining_outlined,
];

int _priceCents(int index) {
  final random = Random(index + 4);
  final rands = 8 + random.nextInt(72);
  final cents = random.nextInt(20) * 5;
  return rands * 100 + cents;
}

final catalogItems = List<CatalogItem>.generate(_productNames.length, (index) {
  return CatalogItem(
    id: 'product-${index + 1}',
    name: _productNames[index],
    priceCents: _priceCents(index),
    icon: _productIcons[index % _productIcons.length],
  );
});
