import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/hive_note.dart';
import '../models/hive_category.dart';
import '../services/hive_service.dart';

class HiveNotesProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final Uuid _uuid = const Uuid();

  List<HiveNote> _notes = [];
  List<HiveCategory> _categories = [];
  List<String> _allTags = [];
  bool _isLoading = true;
  String? _selectedCategoryId;
  String? _selectedTag;
  String _searchQuery = '';

  // Getters
  List<HiveNote> get notes => _notes;
  List<HiveCategory> get categories => _categories;
  List<String> get allTags => _allTags;
  bool get isLoading => _isLoading;
  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedTag => _selectedTag;
  String get searchQuery => _searchQuery;
  List<HiveNote> get pinnedNotes => _notes.where((n) => n.isPinned).toList();
  List<HiveNote> get unpinnedNotes => _notes.where((n) => !n.isPinned).toList();

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _hiveService.init();
    _loadData();

    _isLoading = false;
    notifyListeners();
  }

  void _loadData() {
    _categories = _hiveService.getAllCategories();
    _allTags = _hiveService.getAllTags();

    if (_searchQuery.isNotEmpty) {
      _notes = _hiveService.searchNotes(_searchQuery);
    } else if (_selectedTag != null) {
      _notes = _hiveService.getNotesByTag(_selectedTag!);
    } else if (_selectedCategoryId != null) {
      _notes = _hiveService.getNotesByCategory(_selectedCategoryId!);
    } else {
      _notes = _hiveService.getAllNotes();
    }
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _selectedTag = null;
    _searchQuery = '';
    _loadData();
    notifyListeners();
  }

  void selectTag(String? tag) {
    _selectedTag = tag;
    _selectedCategoryId = null;
    _searchQuery = '';
    _loadData();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _selectedCategoryId = null;
    _selectedTag = null;
    _loadData();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedTag = null;
    _loadData();
    notifyListeners();
  }

  Future<String> addNote(HiveNote note) async {
    final newNote = note.copyWith(id: _uuid.v4());
    await _hiveService.addNote(newNote);
    _loadData();
    notifyListeners();
    return newNote.id;
  }

  Future<void> updateNote(HiveNote note) async {
    await _hiveService.updateNote(note);
    _loadData();
    notifyListeners();
  }

  Future<void> togglePin(String id) async {
    await _hiveService.togglePin(id);
    _loadData();
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _hiveService.deleteNote(id);
    _loadData();
    notifyListeners();
  }

  HiveCategory? getCategoryById(String id) => _hiveService.getCategoryById(id);
  HiveNote? getNoteById(String id) => _hiveService.getNoteById(id);
}
