import 'package:hive/hive.dart';

part 'hive_note.g.dart';

@HiveType(typeId: 1)
class HiveNote extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isPinned;

  @HiveField(7)
  List<String> tags;

  HiveNote({
    required this.id,
    required this.title,
    this.content = '',
    this.categoryId = 'cat_1',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    List<String>? tags,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       tags = tags ?? [];

  HiveNote copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    List<String>? tags,
  }) => HiveNote(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    categoryId: categoryId ?? this.categoryId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPinned: isPinned ?? this.isPinned,
    tags: tags ?? List.from(this.tags),
  );
}
