import 'package:flutter/material.dart';

class CatalogService {
  const CatalogService({
    required this.id,
    required this.name,
    required this.summary,
    required this.icon,
  });

  final String id;
  final String name;
  final String summary;
  final IconData icon;
}

const catalogServices = <CatalogService>[
  CatalogService(
    id: 'brew',
    name: 'Brew',
    summary: 'Espresso and coffee, made to order',
    icon: Icons.coffee_outlined,
  ),
  CatalogService(
    id: 'steep',
    name: 'Steep',
    summary: 'Tea brewed by the cup',
    icon: Icons.emoji_food_beverage_outlined,
  ),
  CatalogService(
    id: 'blend',
    name: 'Blend',
    summary: 'Smoothies and shakes',
    icon: Icons.blender_outlined,
  ),
  CatalogService(
    id: 'press',
    name: 'Press',
    summary: 'Fresh juice, pressed to order',
    icon: Icons.water_drop_outlined,
  ),
  CatalogService(
    id: 'pour',
    name: 'Pour',
    summary: 'Still or sparkling water',
    icon: Icons.local_drink_outlined,
  ),
  CatalogService(
    id: 'plate',
    name: 'Plate',
    summary: 'Something baked to go with your drink',
    icon: Icons.bakery_dining_outlined,
  ),
];
