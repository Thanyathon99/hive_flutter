import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_note.dart';
import '../models/hive_category.dart';

class HiveService {
  static const String notesBoxName = 'notes';
  static const String categoriesBoxName = 'categories';

  late Box<HiveNote> _notesBox;
  late Box<HiveCategory> _categoriesBox;

  // Singleton
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  /// Initialize Hive and register adapters
  Future<void> init() async {
    await Hive.initFlutter();

    // Register Type Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HiveNoteAdapter());
    }

    // Open Boxes
    _categoriesBox = await Hive.openBox<HiveCategory>(categoriesBoxName);
    _notesBox = await Hive.openBox<HiveNote>(notesBoxName);

    // Add default categories if empty
    if (_categoriesBox.isEmpty) {
      for (final category in defaultHiveCategories) {
        await _categoriesBox.put(category.id, category);
      }
    }
  }

  // ========== Categories ==========

  List<HiveCategory> getAllCategories() => _categoriesBox.values.toList();

  HiveCategory? getCategoryById(String id) => _categoriesBox.get(id);

  Future<void> addCategory(HiveCategory category) async {
    await _categoriesBox.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _categoriesBox.delete(id);
  }

  // ========== Notes ==========

  List<HiveNote> getAllNotes() {
    final notes = _notesBox.values.toList();
    // Sort: pinned first, then by updatedAt
    notes.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return notes;
  }

  List<HiveNote> getNotesByCategory(String categoryId) {
    return getAllNotes()
        .where((note) => note.categoryId == categoryId)
        .toList();
  }

  List<HiveNote> searchNotes(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllNotes()
        .where(
          (note) =>
              note.title.toLowerCase().contains(lowerQuery) ||
              note.content.toLowerCase().contains(lowerQuery) ||
              note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  List<HiveNote> getNotesByTag(String tag) {
    return getAllNotes().where((note) => note.tags.contains(tag)).toList();
  }

  HiveNote? getNoteById(String id) => _notesBox.get(id);

  Future<void> addNote(HiveNote note) async {
    await _notesBox.put(note.id, note);
  }

  Future<void> updateNote(HiveNote note) async {
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await _notesBox.put(note.id, updatedNote);
  }

  Future<void> togglePin(String id) async {
    final note = _notesBox.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isPinned: !note.isPinned,
        updatedAt: DateTime.now(),
      );
      await _notesBox.put(id, updated);
    }
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  // ========== Tags ==========

  List<String> getAllTags() {
    final tags = <String>{};
    for (final note in _notesBox.values) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  // ========== Utility ==========

  int get notesCount => _notesBox.length;

  Box<HiveNote> get notesBox => _notesBox;
  Box<HiveCategory> get categoriesBox => _categoriesBox;

  Future<void> clearAll() async {
    await _notesBox.clear();
    await _categoriesBox.clear();
  }

  Future<void> close() async {
    await _notesBox.close();
    await _categoriesBox.close();
  }
}
