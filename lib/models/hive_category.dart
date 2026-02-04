import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_category.g.dart';

@HiveType(typeId: 0)
class HiveCategory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String color;

  @HiveField(3)
  int iconCode;

  HiveCategory({
    required this.id,
    required this.name,
    this.color = '#2196F3',
    this.iconCode = 0xe3b2,
  });

  Color get colorValue {
    final hex = color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  IconData get iconData => IconData(iconCode, fontFamily: 'MaterialIcons');

  HiveCategory copyWith({
    String? id,
    String? name,
    String? color,
    int? iconCode,
  }) => HiveCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    iconCode: iconCode ?? this.iconCode,
  );
}

// Default Categories
final defaultHiveCategories = [
  HiveCategory(id: 'cat_1', name: 'ทั่วไป', color: '#9E9E9E', iconCode: 0xe3b2),
  HiveCategory(id: 'cat_2', name: 'งาน', color: '#2196F3', iconCode: 0xe8f9),
  HiveCategory(
    id: 'cat_3',
    name: 'ส่วนตัว',
    color: '#4CAF50',
    iconCode: 0xe7fd,
  ),
  HiveCategory(id: 'cat_4', name: 'ไอเดีย', color: '#FF9800', iconCode: 0xe90f),
  HiveCategory(id: 'cat_5', name: 'สำคัญ', color: '#F44336', iconCode: 0xe838),
];
